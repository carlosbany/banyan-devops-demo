data "terraform_remote_state" "foundation_layer" {
  backend = "local"

  config = {
    path = "../foundation-layer/terraform.tfstate"
  }
}
