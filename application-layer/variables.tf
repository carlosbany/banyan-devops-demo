variable "region" {
  default = ""
}

variable name {
  type = string
}

variable "banyan_api_key" {
  default = ""
}

variable "banyan_host" {
  default = "https://team.console.banyanops.com"
}

variable vpc_id {
  type = string
}

variable subnet_id {
  type = string
}

variable "key_pair_id" {
  default = ""
}

variable "default_sg" {
  default = ""
}
variable "backend_port" {
  default = ""
}