output "lambda_function_arn" {
  value = aws_lambda_function.sns_to_teams.arn
}

output "lambda_function_name" {
  value = aws_lambda_function.sns_to_teams.function_name
}
