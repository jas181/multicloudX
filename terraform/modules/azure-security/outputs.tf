output "defender_for_servers_enabled" { value = azurerm_security_center_subscription_pricing.virtual_machines.tier == "Standard" }
