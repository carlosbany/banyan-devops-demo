terraform {
  required_providers {
    banyan = {
      source  = "github.com/banyansecurity/banyan"
      version = "0.6.1"
    }
  }
}

provider "banyan" {
  api_token = var.banyan_api_key
  host      = var.banyan_host
}

resource "aws_subnet" "private" {
  vpc_id     = var.vpc_id
  cidr_block = var.private_subnet_cidr_block

  tags = {
    Name = "${var.name}-private"
  }
}

resource "aws_route_table" "private" {
  vpc_id = var.vpc_id
  tags = {
    Name        = "${var.name}-private"
  }
}

resource "aws_route" "private_default" {
  route_table_id         = "${aws_route_table.private.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${var.nat_id}"
}

resource "aws_route_table_association" "private_default" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

resource "aws_security_group" "default" {
  name        = "${var.name}-default"
  description = "Default security group to allow inbound/outbound from the VPC"
  vpc_id      = var.vpc_id

  egress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    cidr_blocks = [aws_subnet.private.cidr_block]
    self      = true
  }
}