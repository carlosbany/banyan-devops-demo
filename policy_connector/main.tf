terraform {
  required_providers {
    banyan = {
      source  = "github.com/banyansecurity/banyan"
      version = "0.6.0"
    }
  }
}

provider "banyan" {
  api_token = var.banyan_api_key
  host      = var.banyan_host
}

resource "banyan_policy_attachment" "infa-high-trust-any" {
  for_each = data.terraform_remote_state.application_layer.outputs.banyan_services_ssh
  policy_id        = banyan_policy.infra-anyone-high.id
  attached_to_type = "service"
  attached_to_id   = each.key
  is_enforcing     = true
}

resource "banyan_policy_attachment" "web-high-trust-any" {
  for_each = data.terraform_remote_state.application_layer.outputs.banyan_services_web
  policy_id        = banyan_policy.web-anyone-high.id
  attached_to_type = "service"
  attached_to_id   = each.key
  is_enforcing     = true
}
