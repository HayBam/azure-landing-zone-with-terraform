# Resource group for hub networking
resource "azurerm_resource_group" "hub" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# Hub Virtual Network
resource "azurerm_virtual_network" "hub" {
  name                = var.vnet_name
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name
  address_space       = var.address_space
  tags                = var.tags
}

# Firewall Subnet (MUST be named AzureFirewallSubnet, MUST be at least /26)
resource "azurerm_subnet" "firewall" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.hub.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = ["10.0.1.0/26"]
}

# Gateway Subnet (for future VPN/ExpressRoute, MUST be named GatewaySubnet)
resource "azurerm_subnet" "gateway" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.hub.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = ["10.0.2.0/27"]
}

# Bastion Subnet (MUST be named AzureBastionSubnet, MUST be at least /26)
resource "azurerm_subnet" "bastion" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.hub.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = ["10.0.3.0/26"]
}

# General-purpose subnet in hub (for shared services like DNS, AD, etc.)
resource "azurerm_subnet" "shared_services" {
  name                 = "snet-shared-services"
  resource_group_name  = azurerm_resource_group.hub.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = ["10.0.4.0/24"]
}

# NSG for shared services subnet
resource "azurerm_network_security_group" "shared_services" {
  name                = "nsg-shared-services"
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name
  tags                = var.tags
}

resource "azurerm_subnet_network_security_group_association" "shared_services" {
  subnet_id                 = azurerm_subnet.shared_services.id
  network_security_group_id = azurerm_network_security_group.shared_services.id
}

# -----------------------------------------------
# Azure Firewall (OPTIONAL — costs ~$1.25 USD/hr)
# Set deploy_firewall = true only when testing
# -----------------------------------------------
resource "azurerm_public_ip" "firewall" {
  count               = var.deploy_firewall ? 1 : 0
  name                = "pip-azfw-hub"
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_firewall" "hub" {
  count               = var.deploy_firewall ? 1 : 0
  name                = "azfw-hub"
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"
  tags                = var.tags

  ip_configuration {
    name                 = "fw-ipconfig"
    subnet_id            = azurerm_subnet.firewall.id
    public_ip_address_id = azurerm_public_ip.firewall[0].id
  }
}

# Firewall network rule collection (example: allow spoke-to-spoke)
resource "azurerm_firewall_network_rule_collection" "spoke_to_spoke" {
  count               = var.deploy_firewall ? 1 : 0
  name                = "allow-spoke-to-spoke"
  azure_firewall_name = azurerm_firewall.hub[0].name
  resource_group_name = azurerm_resource_group.hub.name
  priority            = 100
  action              = "Allow"

  rule {
    name                  = "allow-dev-to-prod"
    source_addresses      = ["10.1.0.0/16"]
    destination_addresses = ["10.2.0.0/16"]
    destination_ports     = ["*"]
    protocols             = ["TCP", "UDP"]
  }
}

# Route table to force spoke traffic through firewall
resource "azurerm_route_table" "spoke_to_firewall" {
  count               = var.deploy_firewall ? 1 : 0
  name                = "rt-spoke-to-firewall"
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name
  tags                = var.tags

  route {
    name                   = "default-to-firewall"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = var.deploy_firewall ? azurerm_firewall.hub[0].ip_configuration[0].private_ip_address : null
  }
}