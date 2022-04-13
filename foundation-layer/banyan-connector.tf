module "banyan_connector" {
  source = "./connector"
  subnet_id = aws_subnet.public.id
  vpc_id = aws_vpc.main.id
  connector_name = "asdfasdf"
  management_cidrs = ["0.0.0.0/0"]
  banyan_api_key = var.banyan_api_key
  banyan_host = var.banyan_host
  region = var.region
}