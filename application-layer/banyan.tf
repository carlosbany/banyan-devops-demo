resource "banyan_service_web" "web" {
  name           = "${var.name}-web"
  description    = "${var.name}-web"
  connector      = "connector2"
  domain         = "${var.name}-web.banyan-595.banyanops.com"
  backend_domain = aws_instance.instance.private_ip
  backend_port   = var.backend_port
  backend_tls    = false
}

resource "banyan_service_infra_ssh" "ssh" {
  name           = "${var.name}-ssh"
  description    = "${var.name}-ssh"
  connector      = "connector2"
  domain         = "${var.name}-ssh.banyan-595.banyanops.com"
  backend_port   = 22
  backend_domain = aws_instance.instance.private_ip
}

resource "banyan_policy" "web-anyone-high" {
  name        = "web-policy"
  description = "Allows web access to everyone with a high trust level"
  access {
    roles       = ["AllUsers"]
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
    roles       = ["AllUsers"]
    trust_level = "High"
  }
  disable_tls_client_authentication = false
}

resource "banyan_policy_attachment" "infa-high-trust-any" {
  policy_id        = banyan_policy.infra-anyone-high.id
  attached_to_type = "service"
  attached_to_id   = banyan_service_infra_ssh.ssh.id
  is_enforcing     = true
}

resource "banyan_policy_attachment" "web-high-trust-any" {
  policy_id        = banyan_policy.web-anyone-high.id
  attached_to_type = "service"
  attached_to_id   = banyan_service_web.web.id
  is_enforcing     = true
}