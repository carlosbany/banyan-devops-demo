locals {
  region = "us-west-2"
  name = "banyan-demo"
  banyan_api_key = ""
  connector_api_key = ""
  banyan_host = "https://team.console.banyanops.com/"
  key_name   = "matt"
  public_key = ""
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

module "application_layer" {
  source = "./application-layer"
  name = local.name
  subnet = module.foundation_layer.aws_subnet_private_id
  connector = module.banyan_connector.connector_name
  banyan_connector_sg = module.banyan_connector.sg
  banyan_api_key = local.banyan_api_key
  banyan_host = local.banyan_host
  key_name = local.key_name
  public_key = local.public_key
  backend_port = 80
  vpc_id = module.foundation_layer.aws_vpc_main_id
}

module "demo-app-2" {
  source = "./application-layer"
  name = "demo-app-2"
  subnet = module.foundation_layer.aws_subnet_private_id
  connector = module.banyan_connector.connector_name
  banyan_connector_sg = module.banyan_connector.sg
  banyan_api_key = local.banyan_api_key
  banyan_host = local.banyan_host
  key_name = local.key_name
  public_key = local.public_key
  backend_port = 80
  vpc_id = module.foundation_layer.aws_vpc_main_id
  key_pair_id = aws_key_pair.ssh-key.id
}

module "demo-app-3" {
  source = "./application-layer"
  name = "demo-app-3"
  subnet = module.foundation_layer.aws_subnet_private_id
  connector = module.banyan_connector.connector_name
  banyan_connector_sg = module.banyan_connector.sg
  banyan_api_key = local.banyan_api_key
  banyan_host = local.banyan_host
  key_name = local.key_name
  public_key = local.public_key
  backend_port = 80
  vpc_id = module.foundation_layer.aws_vpc_main_id
  key_pair_id = aws_key_pair.ssh-key.id
}

module "demo-app-4" {
  source = "./application-layer"
  name = "demo-app-4"
  subnet = module.foundation_layer.aws_subnet_private_id
  connector = module.banyan_connector.connector_name
  banyan_connector_sg = module.banyan_connector.sg
  banyan_api_key = local.banyan_api_key
  banyan_host = local.banyan_host
  key_name = local.key_name
  public_key = local.public_key
  backend_port = 80
  vpc_id = module.foundation_layer.aws_vpc_main_id
  key_pair_id = aws_key_pair.ssh-key.id
}

module "banyan_connector" {
  source = "./terraform-aws-banyan-connector"
  api_key_secret = local.connector_api_key
  subnet_id = module.foundation_layer.aws_subnet_public_id
  vpc_id = module.foundation_layer.aws_vpc_main_id
  connector_name = "connector2"
  management_cidrs = ["0.0.0.0/0"]
}