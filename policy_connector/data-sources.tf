data "terraform_remote_state" "application_layer" {
  backend = "local"

  config = {
    path = "../application-layer/terraform.tfstate"
  }
}