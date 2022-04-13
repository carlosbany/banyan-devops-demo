module "foundation_layer" {
  source = "./foundation-layer"
  name   = local.name
  region = local.region
  banyan_api_key = local.banyan_api_key
}