terraform {
    required_version = ">= 1.0.0, < 2.0.0"
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "3.74.0"
    }
  }
}

provider "aws" {
region = "us-east-2"  
access_key = var.my_access_key
secret_key = var.my_secret_key
}

#This block of code is to ensure that the ami is dynamically gotten irrespective of the region which the instance is launched.
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}


# This resource helps to create an instance named supermario with different parameters.
resource "aws_instance" "supermario" {
  ami = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  security_groups = [aws_security_group.SM_security.name]
  tags = {
    Name = "SuperMario"
  }
  #iam_instance_profile = aws_iam_instance_profile.mario_profile.name

}

# This resource creates the security group with specification for inbound traffic given.
resource "aws_security_group" "SM_security" {
    name = "supermario-instance"
    ingress {
        from_port = var.server_port
        to_port = var.server_port
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
}
