/*
------------------Problem Statement------------------
1. Create IAM users in AWS account with "admin-user-{account-number-of-aws}" syntax.
2. All users from the AWS account.
3. Count of all the users from the AWS account.
*/


terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  access_key = "**********************"
  secret_key = "********************************"
}

data "aws_iam_users" "all-users" {
}

output "all-users" {
  value = data.aws_iam_users.all-users.names
}

output "size" {
  value = length(data.aws_iam_users.all-users.names)
}

data "aws_caller_identity" "current" {
}

resource "aws_iam_user" "sample" {
  name = "sample-${data.aws_caller_identity.current.account_id}"
  path = "/users/"
}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
} 

