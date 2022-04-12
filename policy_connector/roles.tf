resource "banyan_role" "everyone" {
  name              = "admin"
  description       = "Strict role for Admin access"
  user_group        = ["AllUsers"]
  device_ownership  = ["Corporate Dedicated"]
  platform          = ["Windows", "macOS", "Linux"]
}