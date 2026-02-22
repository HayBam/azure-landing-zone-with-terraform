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
  deploy_firewall     = false  # Set to true only when testing firewall rules
}