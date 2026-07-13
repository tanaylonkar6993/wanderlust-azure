output "resource_group_name" {
  value = azurerm_resource_group.wanderlust.name
}

output "vm_public_ip" {
  value = azurerm_public_ip.wanderlust.ip_address
}

output "vm_name" {
  value = azurerm_linux_virtual_machine.jenkins_master.name
}

output "nsg_name" {
  value = azurerm_network_security_group.allow_user_to_connect.name
}

output "aks_cluster_name" {
  value = azurerm_kubernetes_cluster.wanderlust.name
}
