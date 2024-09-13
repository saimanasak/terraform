# Define the AWS provider
provider "aws" {
  region = "us-east-1"
}

# Define the EC2 instance resource
resource "aws_instance" "my_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type

  tags = {
    Name = "my-instance-${terraform.workspace}"
  }
}
