output "spoke_vnet_id" {
  value = azurerm_virtual_network.spoke.id
}

output "spoke_vnet_name" {
  value = azurerm_virtual_network.spoke.name
}

output "workload_subnet_id" {
  value = azurerm_subnet.workload.id
}

output "resource_group_name" {
  value = azurerm_resource_group.spoke.name
}