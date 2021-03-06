terraform {
  required_version = ">= 0.14.11"
  required_providers {
    aws = ">= 3.0"
  }
}

locals {
  filename = "${path.module}/lambda/function.zip"
}

resource "aws_lambda_function" "sns_to_teams" {
  function_name    = "${var.app_name}-sns-to-teams"
  filename         = local.filename
  handler          = "index.handler"
  runtime          = "nodejs14.x"
  role             = aws_iam_role.sns_to_teams.arn
  timeout          = var.timeout
  memory_size      = var.memory_size
  source_code_hash = filebase64sha256(local.filename)
  tags             = var.tags

  environment {
    variables = {
      APP_NAME          = var.app_name
      SEND_TO_TEAMS     = var.send_to_teams
      TEAMS_WEBHOOK_URL = var.teams_webhook_url
    }
  }
}

resource "aws_iam_role" "sns_to_teams" {
  name                 = "${var.app_name}-sns-to-teams-role"
  permissions_boundary = var.role_permissions_boundary
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Effect = "Allow",
        Sid    = ""
      }
    ]
  })
  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "basic_execution" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.sns_to_teams.name
}

resource "aws_cloudwatch_log_group" "logging" {
  name              = "/aws/lambda/${aws_lambda_function.sns_to_teams.function_name}"
  retention_in_days = var.log_retention_in_days
}

resource "aws_lambda_permission" "with_sns" {
  for_each      = var.sns_topic_arns
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.sns_to_teams.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = each.key
}

resource "aws_sns_topic_subscription" "lambda" {
  for_each  = var.sns_topic_arns
  topic_arn = each.key
  protocol  = "lambda"
  endpoint  = aws_lambda_function.sns_to_teams.arn
}
