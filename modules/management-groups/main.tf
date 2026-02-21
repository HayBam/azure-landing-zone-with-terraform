# Get the tenant root management group
data "azurerm_management_group" "tenant_root" {
  display_name = "Tenant Root Group"
}

# Custom root management group
resource "azurerm_management_group" "root" {
  display_name               = var.root_name
  name                       = var.root_id
  parent_management_group_id = data.azurerm_management_group.tenant_root.id
}

# Platform management group
resource "azurerm_management_group" "platform" {
  display_name               = "${var.root_name}-Platform"
  name                       = "${var.root_id}-platform"
  parent_management_group_id = azurerm_management_group.root.id
}

# Platform children
resource "azurerm_management_group" "connectivity" {
  display_name               = "${var.root_name}-Connectivity"
  name                       = "${var.root_id}-connectivity"
  parent_management_group_id = azurerm_management_group.platform.id
}

resource "azurerm_management_group" "management" {
  display_name               = "${var.root_name}-Management"
  name                       = "${var.root_id}-management"
  parent_management_group_id = azurerm_management_group.platform.id
}

resource "azurerm_management_group" "identity" {
  display_name               = "${var.root_name}-Identity"
  name                       = "${var.root_id}-identity"
  parent_management_group_id = azurerm_management_group.platform.id
}

# Landing Zones management group
resource "azurerm_management_group" "landing_zones" {
  display_name               = "${var.root_name}-LandingZones"
  name                       = "${var.root_id}-landingzones"
  parent_management_group_id = azurerm_management_group.root.id
}

# Landing Zone children
resource "azurerm_management_group" "lz_dev" {
  display_name               = "${var.root_name}-Dev"
  name                       = "${var.root_id}-dev"
  parent_management_group_id = azurerm_management_group.landing_zones.id
}

resource "azurerm_management_group" "lz_prod" {
  display_name               = "${var.root_name}-Prod"
  name                       = "${var.root_id}-prod"
  parent_management_group_id = azurerm_management_group.landing_zones.id
}

# Sandbox (for experimentation, separate from production)
resource "azurerm_management_group" "sandbox" {
  display_name               = "${var.root_name}-Sandbox"
  name                       = "${var.root_id}-sandbox"
  parent_management_group_id = azurerm_management_group.root.id
}