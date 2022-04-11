locals {
  region = "us-west-2"
  name = "banyan-demo"
  banyan_api_key = "GL2-Q2Gt8rCWDGL6Gq7zQSV3eldKreZGU7oCZ7P9wjQ"
  connector_api_key = "lR_6G2cq11gQBfyT3gKg9nzaYomTiGVSWh_yh7xZ1yY"
  banyan_host = "https://team.console.banyanops.com/"
  key_name   = "banyan-demo-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCfrFZbCxqMF4wdro+dIfg/MEpqhdByyS8+ou2sLSWkg7iIgOdz4N8LRR2hIXFR9AfnvscBMndMa0KgiixGqwmdJk25W2P0eOmdsTCNOmyA3z7xt1G9+RflzKv0cNWnjF6UtinC+WHOaSBRCt1Td7zD8oLjH0GGoWEpUB7p5MsbLgv/H3VzVejOfuPnO4/JB6RYdFSZSvIOFrzyhnaMMG+7dyyBmtF3r4lfeOuzW/vkBtpRjeh3Ocju61pid0c0KdZPx7MsMPqnrooBFwRhTSPwz1/vsoeQc5eX66bqOt2efJjIcTsRP9ynZeA2zbbClNe8dHPybdQhtNJOOXeRIgoJy5E8DZoYmsjybNyEHpFkouM2Fk7Ni/bLnesvOYqAquNpt02n2cWGT2M3oMNBrTOcsiSXAQIpB80PNlQGgIYLWWtcgcO8pkFx4bFFuE23lIuDVeHHxGsm0raes4lYiQGKDfXJC87Nz3pGvFvDsdFiXB3Wma38Wh3T3TpPfeF3f7c= matt@moviess-MacBook-Pro.local"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = local.region
}

resource "aws_key_pair" "ssh-key" {
  key_name   = local.key_name
  public_key = local.public_key
}

module "foundation_layer" {
  source = "./foundation-layer"
  name = local.name
  region = local.region
}

module "banyan_connector" {
  source = "./terraform-aws-banyan-connector"
  api_key_secret = local.connector_api_key
  subnet_id = module.foundation_layer.aws_subnet_public_id
  vpc_id = module.foundation_layer.aws_vpc_main_id
  connector_name = "connector2"
  management_cidrs = ["0.0.0.0/0"]
}