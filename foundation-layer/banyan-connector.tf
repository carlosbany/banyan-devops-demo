module "banyan_connector" {
  source = "./connector"
  subnet_id = aws_subnet.private.id
  vpc_id = var.vpc_id
  connector_name = "asdfasdff"
  connector_sg = aws_security_group.default.id
  name_prefix = var.name
  management_cidrs = ["0.0.0.0/0"]
  associated_security_groups = [aws_security_group.default.id]
  banyan_api_key = var.banyan_api_key
  banyan_host = var.banyan_host
  region = var.region
}