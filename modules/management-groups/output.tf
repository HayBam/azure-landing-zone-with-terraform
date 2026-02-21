output "root_mg_id" {
  value = azurerm_management_group.root.id
}

output "platform_mg_id" {
  value = azurerm_management_group.platform.id
}

output "connectivity_mg_id" {
  value = azurerm_management_group.connectivity.id
}

output "management_mg_id" {
  value = azurerm_management_group.management.id
}

output "landing_zones_mg_id" {
  value = azurerm_management_group.landing_zones.id
}

output "lz_dev_mg_id" {
  value = azurerm_management_group.lz_dev.id
}

output "lz_prod_mg_id" {
  value = azurerm_management_group.lz_prod.id
}

output "sandbox_mg_id" {
  value = azurerm_management_group.sandbox.id
}