variable name {
  type = string
}

variable region {
  type = string
}

variable "banyan_api_key" {
  default = ""
}

variable "banyan_host" {
  default = "https://team.console.banyanops.com/"
}

variable "connector_name" {
  default = ""
}

variable "vpc_id" {
  default = ""
}

variable "private_subnet_cidr_block" {
  default = ""
}

variable "nat_id" {
  default = ""
}
