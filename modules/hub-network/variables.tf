variable "resource_group_name" {
  description = "Name of the resource group for hub networking"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "vnet_name" {
  description = "Name of the hub virtual network"
  type        = string
}

variable "address_space" {
  description = "Address space for the hub VNet"
  type        = list(string)
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
}

variable "deploy_firewall" {
  description = "Whether to deploy Azure Firewall. Set false to save cost."
  type        = bool
  default     = false
}

variable "log_analytics_workspace_id" {
  description = "Log Analytics workspace ID for diagnostics"
  type        = string
  default     = ""
}