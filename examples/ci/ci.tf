terraform {
  required_version = ">= 0.14.11"
  required_providers {
    aws = "~> 3.0"
  }
}

provider "aws" {
  region = "us-west-2"
}

module "ci_test" {
  source                    = "../../"
  app_name                  = "test"
  role_permissions_boundary = module.acs.role_permissions_boundary.arn
  teams_webhook_url         = "https://byu.webhook.office.com/webhookb2/FAKE/URL"
  sns_topic_arns            = ["arn:aws:sns:us-west-2:977306314792:fake-sns-arn"]
}

module "acs" {
  source = "github.com/byu-oit/terraform-aws-acs-info?ref=v3.2.0"
}
