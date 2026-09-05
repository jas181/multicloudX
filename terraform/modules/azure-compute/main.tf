resource "azurerm_lb" "internal" {
  name                = "ilb-${var.name_prefix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"
  tags                = var.tags
  frontend_ip_configuration {
    name                          = "private"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_lb_backend_address_pool" "app" {
  loadbalancer_id = azurerm_lb.internal.id
  name            = "app"
}

resource "azurerm_lb_probe" "app" {
  loadbalancer_id = azurerm_lb.internal.id
  name            = "http-health"
  protocol        = "Http"
  port            = 8080
  request_path    = "/health"
}

resource "azurerm_lb_rule" "app" {
  loadbalancer_id                = azurerm_lb.internal.id
  name                           = "http"
  protocol                       = "Tcp"
  frontend_port                  = 8080
  backend_port                   = 8080
  frontend_ip_configuration_name = "private"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.app.id]
  probe_id                       = azurerm_lb_probe.app.id
}

resource "azurerm_linux_virtual_machine_scale_set" "app" {
  name                = "vmss-${var.name_prefix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard_B2s"
  instances           = 2
  admin_username      = "platformadmin"
  upgrade_mode        = "Automatic"
  zones               = ["1", "2"]
  tags                = var.tags
  admin_ssh_key {
    username   = "platformadmin"
    public_key = var.admin_ssh_public_key
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
  os_disk {
    storage_account_type = "StandardSSD_LRS"
    caching              = "ReadWrite"
  }
  network_interface {
    name    = "app"
    primary = true
    ip_configuration {
      name                                   = "internal"
      primary                                = true
      subnet_id                              = var.subnet_id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.app.id]
    }
  }
  identity { type = "SystemAssigned" }
}

resource "azurerm_monitor_autoscale_setting" "app" {
  name                = "autoscale-${var.name_prefix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  target_resource_id  = azurerm_linux_virtual_machine_scale_set.app.id
  profile {
    name = "default"
    capacity {
      default = 2
      minimum = 2
      maximum = 4
    }
    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.app.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 70
      }
      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT5M"
      }
    }
  }
  tags = var.tags
}
