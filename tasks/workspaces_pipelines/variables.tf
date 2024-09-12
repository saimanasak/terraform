variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "ami_id" {
  description = "The AMI ID to use for the EC2 instance."
  type        = string
}

variable "instance_type" {
  description = "Type of EC2 instance"
  type        = string
}
