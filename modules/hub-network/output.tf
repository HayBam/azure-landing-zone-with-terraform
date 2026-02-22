output "hub_vnet_id" {
  value = azurerm_virtual_network.hub.id
}

output "hub_vnet_name" {
  value = azurerm_virtual_network.hub.name
}

output "hub_resource_group_name" {
  value = azurerm_resource_group.hub.name
}

output "firewall_private_ip" {
  value = var.deploy_firewall ? azurerm_firewall.hub[0].ip_configuration[0].private_ip_address : null
}

output "route_table_id" {
  value = var.deploy_firewall ? azurerm_route_table.spoke_to_firewall[0].id : null
}