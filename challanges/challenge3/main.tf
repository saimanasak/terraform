/*
------------------Problem Statement------------------
1. Based on the values specified in map, EC2 instances should be created.
2. If key/value is removed from map, EC2 instances must be destroyed.
*/


variable "instance_config" {
  type = map
  default = {
    instance1 = { instance_type = "t2.micro", ami = "ami-03a6eaae9938c858c" }
    instance2 = { instance_type = "t2.small", ami = "ami-053b0d53c279acc90" }
  }
}

resource "aws_instance" "third" {
  for_each = var.instance_config
  instance_type = each.value.instance_type
  ami = each.value.ami
}

