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
  region = local.region
}

provider "banyan" {
  api_token = local.banyan_api_key
  host      = local.banyan_host
}

