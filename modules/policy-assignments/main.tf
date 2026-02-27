# -----------------------------------------------
# Policy 1: Allowed Locations (restrict to Canada)
# Applied at: Root management group (affects everything)
# Effect: Deny — blocks resource creation in non-allowed regions
# Why: Data sovereignty and compliance
# -----------------------------------------------
resource "azurerm_management_group_policy_assignment" "allowed_locations" {
  name                 = "allowed-locations"
  display_name         = "Allowed Locations - Canada Only"
  description          = "Restricts resource deployment to Canadian Azure regions for data sovereignty compliance."
  management_group_id  = var.root_mg_id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c"

  parameters = jsonencode({
    listOfAllowedLocations = {
      value = var.allowed_locations
    }
  })
}

# -----------------------------------------------
# Policy 2: Require tags on resource groups
# Applied at: Landing Zones management group
# Effect: Deny — blocks RG creation without required tags
# Why: Cost tracking and resource ownership
# -----------------------------------------------
resource "azurerm_management_group_policy_assignment" "require_owner_tag" {
  name                 = "require-owner-tag"
  display_name         = "Require Owner Tag on Resource Groups"
  description          = "All resource groups must have an Owner tag for accountability and cost tracking."
  management_group_id  = var.landing_zones_mg_id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/96670d01-0a4d-4649-9c89-2d3abc0a5025"

  parameters = jsonencode({
    tagName = {
      value = "Owner"
    }
  })
}

# -----------------------------------------------
# Policy 3: Require tags on resource groups (Environment)
# Applied at: Landing Zones management group
# Effect: Deny
# Why: Environment identification for governance
# -----------------------------------------------
resource "azurerm_management_group_policy_assignment" "require_env_tag" {
  name                 = "require-env-tag"
  display_name         = "Require Environment Tag on Resource Groups"
  description          = "All resource groups must have an Environment tag."
  management_group_id  = var.landing_zones_mg_id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/96670d01-0a4d-4649-9c89-2d3abc0a5025"

  parameters = jsonencode({
    tagName = {
      value = "Environment"
    }
  })
}

# -----------------------------------------------
# Policy 4: Audit VMs that don't use managed disks
# Applied at: Root management group
# Effect: Audit — flags non-compliant resources but doesn't block
# Why: Managed disks are best practice for reliability
# -----------------------------------------------
resource "azurerm_management_group_policy_assignment" "audit_managed_disks" {
  name                 = "audit-managed-disks"
  display_name         = "Audit VMs Without Managed Disks"
  description          = "Identifies VMs using unmanaged disks for remediation planning."
  management_group_id  = var.root_mg_id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/06a78e20-9358-41c9-923c-fb736d382a4d"
}

# -----------------------------------------------
# Policy 5: Deny public IP on NICs in Prod
# Applied at: Prod management group
# Effect: Deny — prevents direct internet exposure in prod
# Why: Security — prod workloads should only be accessible through firewall/load balancer
# -----------------------------------------------
resource "azurerm_management_group_policy_assignment" "deny_public_ip_prod" {
  name                 = "deny-public-ip-prod"
  display_name         = "Deny Public IPs on NICs in Production"
  description          = "Prevents creation of public IP addresses on network interfaces in production to enforce traffic through the centralized firewall."
  management_group_id  = var.prod_mg_id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/83a86a26-fd1f-447c-b59d-e51f44264114"
}