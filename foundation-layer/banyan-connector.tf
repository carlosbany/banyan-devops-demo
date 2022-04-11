module "banyan_connector" {
  source = "github.com/banyansecurity/terraform-aws-banyan-connector"
  api_key_secret = var.connector_api_key
  subnet_id = aws_subnet.private.id
  vpc_id = aws_vpc.main.id
  connector_name = "default-connector"
  management_cidrs = ["0.0.0.0/0"]
}