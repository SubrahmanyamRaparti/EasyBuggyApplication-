provider "aws" {
  region = "ap-south-1"
}

data "aws_vpc" "selected" {}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

# A Linux server for Jenkins to RUN.
module "aws_instance" {
  source                 = "git::https://github.com/SubrahmanyamRaparti/Terraform.git//terraform-aws-ec2"
  instance_type          = "t3.small"
  vpc_security_group_ids = [aws_security_group.aws_security_group.id]
  key_name               = var.key_name
  name                   = "Jenkins Server"
  iam_instance_profile   = aws_iam_instance_profile.aws_iam_instance_profile.id
}

# Runs a Ansible script and install jenkins and tools
resource "null_resource" "inventory" {
  depends_on = [module.aws_instance]
  provisioner "local-exec" {
    command = "sh get_server_ip.sh"
  }
  
  triggers = {
    always_run = "${timestamp()}"
  }
}

# Deletes the inventory file when the infrastructure is destroyed.
resource "null_resource" "playbook" {
  provisioner "local-exec" {
    command = "rm ../inventory.txt"
    when = destroy
  }
}

# AWS ECR container repository to store container images.
module "aws_ecr_repository" {
  source = "git::https://github.com/SubrahmanyamRaparti/Terraform.git//terraform-aws-ecr"
  name   = "easybuggyapplication"
}

# Security group - Firewall to allow / deny.
resource "aws_security_group" "aws_security_group" {
  name        = "Allow taffic for Jenkins server"
  description = "Allow TLS inbound traffic"
  vpc_id      = data.aws_vpc.selected.id

  dynamic "ingress" {
    for_each = local.rules
    iterator = rule
    content {
      description = "Allow inbound traffic"
      from_port   = rule.value.port
      to_port     = rule.value.port
      protocol    = "tcp"
      cidr_blocks = [rule.value.cidr_block]
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "Jenkins Server SG"
  }
}