module "foundation_layer" {
  source = "./foundation-layer"
  name   = local.name
  region = local.region
  banyan_api_key = local.banyan_api_key
  vpc_id = local.vpc_id
  nat_id = local.nat_id
  private_subnet_cidr_block = local.private_subnet_cidr_block
}