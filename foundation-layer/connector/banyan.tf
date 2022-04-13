resource "banyan_api_key" "connector" {
  name              = var.connector_name
  description       = var.connector_name
  scope             = "satellite"
}

resource "banyan_connector" "example" {
  name              = var.connector_name
  satellite_api_key_id = banyan_api_key.connector.id
}
