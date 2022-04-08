locals {
  region = "us-west-2"
  name = "banyan-demo"
  banyan_api_key = "GL2-Q2Gt8rCWDGL6Gq7zQSV3eldKreZGU7oCZ7P9wjQ"
  banyan_host = "https://team.console.banyanops.com/"
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
  connector = "default-connector"
  banyan_api_key = local.banyan_api_key
  banyan_host = local.banyan_host
}

module "banyan_connector" {
  source = "./terraform-aws-banyan-connector"
  api_key_secret = local.banyan_api_key
  subnet_id = module.foundation_layer.aws_subnet_private_id
  vpc_id = module.foundation_layer.aws_vpc_main_id
  connector_name = "default-connector"
}
