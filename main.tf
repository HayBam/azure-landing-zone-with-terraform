# -----------------------------------------------
# Management Group Hierarchy
# -----------------------------------------------
module "management_groups" {
  source    = "./modules/management-groups"
  root_name = var.root_management_group_name
  root_id   = "ayo-enterprise"
}