output "aws_subnet_private_id" {
  value = aws_subnet.private.id
}

output "connector_sg" {
  value = module.banyan_connector.sg
}

output "connector_name" {
  value = module.banyan_connector.connector_name
}