locals {
  region = "us-west-2"
  name = "banyan-demo"
  banyan_api_key = ""
  connector_api_key = ""
  banyan_host = "https://team.console.banyanops.com/"
  key_name   = "matt"
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


module "foundation_layer" {
  source = "./foundation-layer"
  name = local.name
  region = local.region
}

module "application_layer" {
  source = "./application-layer"
  name = local.name
  subnet = module.foundation_layer.aws_subnet_private_id
  connector = module.banyan_connector.connector_name
  banyan_connector_sg = module.banyan_connector.sg
  banyan_api_key = local.connector_api_key
  banyan_host = local.banyan_host
  key_name = local.key_name
  public_key = local.public_key
  backend_port = 8443
  vpc_id = module.foundation_layer.aws_vpc_main_id
}

module "banyan_connector" {
  source = "./terraform-aws-banyan-connector"
  api_key_secret = local.connector_api_key
  subnet_id = module.foundation_layer.aws_subnet_public_id
  vpc_id = module.foundation_layer.aws_vpc_main_id
  connector_name = "connector2"
  ssh_key_name = module.application_layer.key_pair_id
  management_cidrs = ["0.0.0.0/0"]
}