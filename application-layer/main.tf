terraform {
  required_providers {
    banyan = {
      source  = "github.com/banyansecurity/banyan"
      version = "0.6.1"
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

resource "aws_key_pair" "ssh-key" {
  key_name   = var.key_name
  public_key = var.public_key
}

data "aws_ami" "ubuntu-docker" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu-xenial-docker-stable-latest*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["654814900965"] # Canonical
}

resource "aws_instance" "instance" {
  ami           = data.aws_ami.ubuntu-docker.id
  instance_type = "t3.micro"
  subnet_id = data.terraform_remote_state.foundation_layer.outputs.aws_subnet_private_id
  key_name = aws_key_pair.ssh-key.id
  tags = {
    Name = "${var.name}-instance"
  }
  user_data = join("", concat([
    "#!/bin/bash -ex\n",
    "INSTANCE_ID=\"${var.name}\"\n",
    "export PRIVATE_IP=\"$(hostname -i | awk '{print $3}')\"\n",
    "docker run -e INSTANCE_ID -e PRIVATE_IP -p 80:80 gcr.io/banyan-pub/demo-site\n"
  ]))
  vpc_security_group_ids = [aws_security_group.allow-connector.id]
}

resource "aws_security_group" "allow-connector" {
  name        = "${var.name}-connector"
  description = "Allow all traffic from banyan connector"
  vpc_id      = data.terraform_remote_state.foundation_layer.outputs.aws_vpc_main_id

  ingress {
    security_groups   = [data.terraform_remote_state.foundation_layer.outputs.connector_sg]
    from_port         = 0
    to_port           = 0
    protocol          = "all"
    description       = "allow all from banyan connector"
  }
}