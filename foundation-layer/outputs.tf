output "aws_vpc_main_id" {
  value = aws_vpc.main.id
}

output "aws_subnet_private_id" {
  value = aws_subnet.private.id
}

output "aws_subnet_public_id" {
  value = aws_subnet.public.id
}

output "connector_sg" {
  value = module.banyan_connector.sg
}