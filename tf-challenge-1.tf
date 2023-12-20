/*
------------------Problem Statement------------------
1. Create an infrastructure using the code.
2. Verify if the code works in the latest version of Terraform and Provider.
3. Modify and fix the code so that it works with the latest version.
*/

provider "aws" {
  region     = "us-east-2"
  access_key = "*******************"
  secret_key = "***************************"
}

#provider "digitalocean" {}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.30.0"
    }
  }
}

resource "aws_instance" "first" {
  ami           = "ami-06d4b7182ac3480fa"
  instance_type = "t2.micro"
}

resource "aws_eip" "kplabs_app_ip" {
  instance = aws_instance.first.id
  domain = "vpc"
}
