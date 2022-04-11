terraform {
  required_providers {
    banyan = {
      source  = "github.com/banyansecurity/banyan"
      version = "0.6.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}
provider "aws" {
  region = var.region
}


provider "banyan" {
  api_token = var.banyan_api_key
  host      = var.banyan_host
}


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

resource "aws_instance" "instance" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  subnet_id = var.subnet_id
  key_name = var.key_pair_id

  tags = {
    Name = "${var.name}-instance"
  }

  user_data = join("", concat([
    "#!/bin/bash -ex\n",
    "curl -L https://github.com/banyansecurity/banyan-devops-demo/releases/download/v0.16/release.tar.gz > release.tar.gz\n",
    "sudo tar -xzvf release.tar.gz\n",
    "sudo sh demo-site/docker-run.sh\n"
  ]))

  vpc_security_group_ids = [var.default_sg]
}

resource "aws_security_group" "allow-connector" {
  name        = "${var.name}-connector"
  description = "Connector engress traffic (no ingress needed)"
  vpc_id      = var.vpc_id

  ingress {
    security_groups   = [var.default_sg]
    from_port         = 0
    to_port           = 0
    protocol          = "tcp"
    description       = "backend port"
  }

}