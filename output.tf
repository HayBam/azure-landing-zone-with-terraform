output "management_group_root_id" {
  value = module.management_groups.root_mg_id
}

output "subscription_association" {
  value = "Subscription ${var.subscription_id} associated with ${module.management_groups.root_mg_id}"
  sensitive = true
}

output "hub_vnet_id" {
  value = module.hub_network.hub_vnet_id
}

output "dev_spoke_vnet_id" {
  value = module.dev_spoke.spoke_vnet_id
}

output "prod_spoke_vnet_id" {
  value = module.prod_spoke.spoke_vnet_id
}

output "log_analytics_workspace_id" {
  value = module.monitoring.log_analytics_workspace_id
}

output "policy_summary" {
  value = module.policy_assignments.policy_assignments
}