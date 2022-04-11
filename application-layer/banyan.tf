
resource "banyan_service_web" "admin-console" {
  name           = "${var.name}-web"
  description    = "${var.name}-web"
  connector      = "connector2"
  domain         = "${var.name}-web.banyan-595.banyanops.com"
  backend_domain = aws_instance.instance.private_ip
  backend_port   = var.backend_port
  backend_tls    = false
}

resource "banyan_service_infra_ssh" "admin-ssh" {
  name           = "${var.name}-ssh"
  description    = "${var.name}-ssh"
  connector      = "connector2"
  domain         = "${var.name}-ssh.banyan-595.banyanops.com"
  backend_port   = 22
  backend_domain = aws_instance.instance.private_ip
}

output "banyan_services_web" {
  value = toset([banyan_service_web.admin-console.id])
}

output "banyan_services_ssh" {
  value = toset([banyan_service_infra_ssh.admin-ssh.id])
}