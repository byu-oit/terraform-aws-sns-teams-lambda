provider "aws" {
  version = "~> 3.0"
  region  = "us-west-2"
}

module "sns_teams_lambda" {
  source = "github.com/byu-oit/terraform-aws-sns-teams-lambda?ref=v1.0.0"
  #source = "../" # for local testing during module development
}
