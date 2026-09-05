output "vmss_id" { value = azurerm_linux_virtual_machine_scale_set.app.id }
output "internal_load_balancer_id" { value = azurerm_lb.internal.id }
