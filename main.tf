# -----------------------------------------------
# Subscription Association
# Moves the subscription from Tenant Root Group into our custom root MG 
# -----------------------------------------------
resource "azurerm_management_group_subscription_association" "root" {
  management_group_id = module.management_groups.root_mg_id
  subscription_id     = "/subscriptions/${var.subscription_id}"
}

# -----------------------------------------------
# Management Group Hierarchy
# -----------------------------------------------
module "management_groups" {
  source    = "./modules/management-groups"
  root_name = var.root_management_group_name
  root_id   = "ayo-enterprise"
}

# -----------------------------------------------
# Hub Network
# -----------------------------------------------
module "hub_network" {
  source              = "./modules/hub-network"
  resource_group_name = "rg-hub-connectivity"
  location            = var.location
  vnet_name           = "vnet-hub"
  address_space       = var.hub_vnet_address_space
  tags                = var.tags
  deploy_firewall     = false  # Set to true when testing firewall rules

  depends_on = [azurerm_management_group_subscription_association.root]
}

# -----------------------------------------------
# Dev Spoke Network
# -----------------------------------------------
module "dev_spoke" {
  source                  = "./modules/spoke-network"
  resource_group_name     = "rg-spoke-dev"
  location                = var.location
  vnet_name               = "vnet-spoke-dev"
  address_space           = var.dev_spoke_address_space
  workload_subnet_prefix  = "10.1.1.0/24"
  hub_vnet_id             = module.hub_network.hub_vnet_id
  hub_vnet_name           = module.hub_network.hub_vnet_name
  hub_resource_group_name = module.hub_network.hub_resource_group_name
  route_table_id          = module.hub_network.route_table_id != null ? module.hub_network.route_table_id : ""
  tags                    = var.tags
  environment             = "dev"

  depends_on = [azurerm_management_group_subscription_association.root]
}

# -----------------------------------------------
# Prod Spoke Network
# -----------------------------------------------
module "prod_spoke" {
  source                  = "./modules/spoke-network"
  resource_group_name     = "rg-spoke-prod"
  location                = var.location
  vnet_name               = "vnet-spoke-prod"
  address_space           = var.prod_spoke_address_space
  workload_subnet_prefix  = "10.2.1.0/24"
  hub_vnet_id             = module.hub_network.hub_vnet_id
  hub_vnet_name           = module.hub_network.hub_vnet_name
  hub_resource_group_name = module.hub_network.hub_resource_group_name
  route_table_id          = module.hub_network.route_table_id != null ? module.hub_network.route_table_id : ""
  tags                    = var.tags
  environment             = "prod"

  depends_on = [azurerm_management_group_subscription_association.root]
}

# -----------------------------------------------
# Azure Policy Assignments
# -----------------------------------------------
module "policy_assignments" {
  source              = "./modules/policy-assignments"
  root_mg_id          = module.management_groups.root_mg_id
  landing_zones_mg_id = module.management_groups.landing_zones_mg_id
  prod_mg_id          = module.management_groups.lz_prod_mg_id
  allowed_locations   = ["canadacentral", "canadaeast"]

  depends_on = [azurerm_management_group_subscription_association.root]
}