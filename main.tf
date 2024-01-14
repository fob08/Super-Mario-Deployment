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
  iam_instance_profile = aws_iam_instance_profile.mario_profile.name

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

#This is used to create an iam policy with the access of an administrator.
resource "aws_iam_policy" "mario_policy" {
  name = "mario_admin_policy"
  path = "/"
  description = "This policy provides admin access role"
  policy = jsonencode({
  "Version" : "2012-10-17",
  "Statement" : [
    {
      "Effect" : "Allow",
      "Action" : "*",
      "Resource" : "*"
    }
  ]
})
}

# After the policy is created, a role is needed which the policy will be attached to.
resource "aws_iam_role" "SuperMario" {
  name = "SuperMario_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
  description = "This role allow for EC2 instance to call AWS services on behalf of a user"
}

# This resource block helps to attach the role and the created policy together.
resource "aws_iam_role_policy_attachment" "mario" {
  role = aws_iam_role.SuperMario.name
  policy_arn = aws_iam_policy.mario_policy.arn
}

# Creating an instance profile for the EC2
resource "aws_iam_instance_profile" "mario_profile" {
  name = "SuperMario-profile"
  role = aws_iam_role.SuperMario.name
}
