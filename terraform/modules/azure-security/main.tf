resource "azurerm_security_center_subscription_pricing" "virtual_machines" {
  resource_type = "VirtualMachines"
  tier          = "Standard"
}

resource "azurerm_security_center_contact" "this" {
  name                = "multicloudx-platform"
  email               = var.security_contact_email
  phone               = "+10000000000"
  alert_notifications = true
  alerts_to_admins    = true
}
