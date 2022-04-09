variable name {
  type = string
}

variable vpc_id {
  type = string
}

variable subnet {
  type = string
}

variable "banyan_api_key" {
  default = ""
}

variable "banyan_host" {
  default = "https://team.console.banyanops.com"
}

variable "connector" {
  default = ""
}

variable "backend_port" {
  default = ""
}

variable "cluster" {
  default = "global-edge"
}

variable "key_name" {
  default = ""
}

variable "public_key" {
  default = ""
}

variable "banyan_connector_sg" {
  default = ""
}

variable "key_pair_id" {
  default = ""
}