/*
------------------Problem Statement------------------
1. Fix the code.
2. Ability to modify variable "splunk" from 8088 to 8089 without modifying the terraform code.
*/

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"

    }
  }
}

provider "aws" {
  region = "us-east-2"
  access_key = "*********************"
  secret_key = "*********************************"
}

variable "splunk" {
  default = "8088"
}
resource "aws_security_group" "security_group_payment_app" {
  name        = "payment_app"
  description = "Application Security Group"
  depends_on  = [aws_eip.example]

  # Below ingress allows HTTPS  from DEV VPC
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["172.31.0.0/16"]
  }

  # Below ingress allows APIs access from DEV VPC

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["172.31.0.0/16"]
  }

  # Below ingress allows APIs access from Prod App Public IP.

  ingress {
    from_port   = 8443
    to_port     = 8443
    protocol    = "tcp"
    cidr_blocks = ["${aws_eip.example.public_ip}/32"]
  }

  egress {
    from_port   = var.splunk
    to_port     = var.splunk
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_eip" "example" {
  #domain = "vpc"
}