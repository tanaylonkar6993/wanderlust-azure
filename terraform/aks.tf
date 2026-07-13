resource "azurerm_kubernetes_cluster" "wanderlust" {
  name                = var.aks_cluster_name
  location            = azurerm_resource_group.wanderlust.location
  resource_group_name = azurerm_resource_group.wanderlust.name
  dns_prefix          = var.aks_cluster_name
  kubernetes_version  = var.kubernetes_version

  default_node_pool {
    name       = "default"
    node_count = var.node_count
    vm_size    = var.node_vm_size
  }

  identity {
    type = "SystemAssigned"
  }

  timeouts {
    create = "150m"
  }

  tags = {
    Name = "wanderlust"
  }
}
