module "banyan_connector" {
  source = "/Users/matt/Documents/git/terraform-aws-banyan-connector"
  subnet_id = aws_subnet.public.id
  vpc_id = aws_vpc.main.id
  connector_name = "newconnector"
  management_cidrs = ["0.0.0.0/0"]
  banyan_api_key = "xGB4vs0w12r1J2SxnmJXuceFzBvrT9Hrn-ptViZ2aYA"
}