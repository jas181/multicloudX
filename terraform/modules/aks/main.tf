resource "azurerm_kubernetes_cluster" "this" {
  name                                = "aks-${var.name_prefix}"
  location                            = var.location
  resource_group_name                 = var.resource_group_name
  dns_prefix                          = "aks-${var.name_prefix}"
  private_cluster_enabled             = true
  private_cluster_public_fqdn_enabled = false
  azure_policy_enabled                = true
  oidc_issuer_enabled                 = true
  workload_identity_enabled           = true
  sku_tier                            = "Free"
  tags                                = var.tags
  default_node_pool {
    name                 = "system"
    vm_size              = "Standard_B4ms"
    vnet_subnet_id       = var.subnet_id
    auto_scaling_enabled = true
    min_count            = 2
    max_count            = 4
    node_labels          = { workload = "system" }
  }
  identity { type = "SystemAssigned" }
  network_profile {
    network_plugin = "azure"
    network_policy = "azure"
  }
}
