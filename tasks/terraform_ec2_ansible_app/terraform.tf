provider "aws" {
  region     = "us-east-2"                     # Specifies the AWS region where resources will be created.
  access_key = "********************"          # AWS access key for authentication.
  secret_key = "****************************"  # AWS secret key for authentication.
}

resource "aws_instance" "myserver" {
  ami           = "ami-05c3dc660cb6907f0"           # Amazon Machine Image ID for the EC2 instance.
  instance_type = "t2.micro"                        # Instance type, specifying the hardware configuration of the EC2 instance.
  key_name      = "smkeypair"                       # Name of the SSH key pair used to connect to the instance.
  vpc_security_group_ids = ["sg-03d4b8b4aec57ee34"] # List of security group IDs to associate with the instance.

  tags = {
    Name = "By Terraform"                  # Tags to assign to the instance.
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",                # Command to update all packages on the instance.
      "sudo yum install -y python3",       # Command to install Python3 on the instance.
    ]

    connection {
      type        = "ssh"                        # Type of connection used to communicate with the instance.
      user        = "ec2-user"                   # Username for SSH access to the instance (default for Amazon Linux).
      private_key = file("~/.ssh/smkeypair.pem") # Path to the private key file for SSH authentication.
      host        = self.public_ip               # Public IP address of the instance for SSH connection.
    }
  }
}

output "instance_ip" {
  value = aws_instance.myserver.public_ip  # Output of the public IP address of the EC2 instance.
}
