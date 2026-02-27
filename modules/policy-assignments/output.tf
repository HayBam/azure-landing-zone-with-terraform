output "allowed_locations_policy_id" {
  value = azurerm_management_group_policy_assignment.allowed_locations.id
}

output "policy_assignments" {
  value = [
    "Allowed Locations (Root): Deny non-Canadian regions",
    "Require Owner Tag (Landing Zones): Deny RGs without Owner tag",
    "Require Environment Tag (Landing Zones): Deny RGs without Environment tag",
    "Audit Managed Disks (Root): Audit VMs without managed disks",
    "Deny Public IPs (Prod): Block public IPs on NICs in production",
  ]
}