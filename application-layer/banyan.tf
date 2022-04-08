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

resource "banyan_service_web" "admin-console" {
  name           = "${var.name}-web"
  description    = "${var.name}-web"
  cluster        = var.cluster
  connector      = var.connector
  domain         = var.name
  port           = 443
  backend_domain = aws_instance.instance.private_ip
  backend_port   = 8443
  backend_tls    = true
}

resource "banyan_service_infra_ssh" "admin-console" {
  name           = "${var.name}-ssh"
  description    = "${var.name}-ssh"
  cluster        = var.cluster
  connector      = var.connector
  domain         = var.name
  backend_port   = 22
  backend_domain = aws_instance.instance.private_ip
}

resource "banyan_policy_attachment" "infa-high-trust-any" {
  policy_id        = banyan_policy.infra-anyone-high.id
  attached_to_type = "service"
  attached_to_id   = banyan_service_infra_ssh.admin-console.id
  is_enforcing     = true
}

resource "banyan_policy" "web-anyone-high" {
  name        = "web-policy"
  description = "Allows web access to everyone with a high trust level"
  access {
    roles       = [banyan_role.everyone.name]
    trust_level = "High"
    l7_access {
      resources = ["*"]
      actions   = ["*"]
    }
  }
  l7_protocol                       = "http"
  disable_tls_client_authentication = true
}

resource "banyan_policy" "infra-anyone-high" {
  name        = "infrastructure-policy"
  description = "some infrastructure policy description"
  access {
    roles       = [banyan_role.everyone.name]
    trust_level = "High"
  }
  disable_tls_client_authentication = false
}

resource "banyan_role" "everyone" {
  name              = "admin"
  description       = "Strict role for Admin access"
  user_group        = ["AllUsers"]
  device_ownership  = ["Corporate Dedicated"]
  platform          = ["Windows", "macOS", "Linux"]
}

resource "banyan_policy_attachment" "example-high-trust-any" {
  policy_id        = banyan_policy.web-anyone-high.id
  attached_to_type = "service"
  attached_to_id   = banyan_service_web.admin-console.id
  is_enforcing     = true
}