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
