# Resource group for this spoke
resource "azurerm_resource_group" "spoke" {
  name     = var.resource_group_name
  location = var.location
  tags     = merge(var.tags, { Environment = var.environment })
}

# Spoke Virtual Network
resource "azurerm_virtual_network" "spoke" {
  name                = var.vnet_name
  location            = azurerm_resource_group.spoke.location
  resource_group_name = azurerm_resource_group.spoke.name
  address_space       = var.address_space
  tags                = merge(var.tags, { Environment = var.environment })
}

# Workload Subnet
resource "azurerm_subnet" "workload" {
  name                 = "snet-workload-${var.environment}"
  resource_group_name  = azurerm_resource_group.spoke.name
  virtual_network_name = azurerm_virtual_network.spoke.name
  address_prefixes     = [var.workload_subnet_prefix]
}

# NSG for workload subnet
resource "azurerm_network_security_group" "workload" {
  name                = "nsg-workload-${var.environment}"
  location            = azurerm_resource_group.spoke.location
  resource_group_name = azurerm_resource_group.spoke.name
  tags                = merge(var.tags, { Environment = var.environment })

  # Deny all inbound from internet (default is deny, but being explicit)
  security_rule {
    name                       = "DenyAllInbound"
    priority                   = 4096
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }

  # Allow inbound from hub (shared services)
  security_rule {
    name                       = "AllowHubInbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "10.0.0.0/16"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "workload" {
  subnet_id                 = azurerm_subnet.workload.id
  network_security_group_id = azurerm_network_security_group.workload.id
}

# Route table association (if firewall is deployed)
resource "azurerm_subnet_route_table_association" "workload" {
  count          = var.route_table_id != "" ? 1 : 0
  subnet_id      = azurerm_subnet.workload.id
  route_table_id = var.route_table_id
}

# -----------------------------------------------
# VNet Peering: Spoke → Hub
# -----------------------------------------------
resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  name                      = "peer-${var.vnet_name}-to-hub"
  resource_group_name       = azurerm_resource_group.spoke.name
  virtual_network_name      = azurerm_virtual_network.spoke.name
  remote_virtual_network_id = var.hub_vnet_id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
}

# -----------------------------------------------
# VNet Peering: Hub → Spoke
# -----------------------------------------------
resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  name                      = "peer-hub-to-${var.vnet_name}"
  resource_group_name       = var.hub_resource_group_name
  virtual_network_name      = var.hub_vnet_name
  remote_virtual_network_id = azurerm_virtual_network.spoke.id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
}