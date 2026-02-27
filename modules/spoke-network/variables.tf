variable "resource_group_name" {
  description = "Name of the resource group for this spoke"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "vnet_name" {
  description = "Name of the spoke VNet"
  type        = string
}

variable "address_space" {
  description = "Address space for the spoke VNet"
  type        = list(string)
}

variable "workload_subnet_prefix" {
  description = "Address prefix for the workload subnet"
  type        = string
}

variable "hub_vnet_id" {
  description = "Resource ID of the hub VNet for peering"
  type        = string
}

variable "hub_vnet_name" {
  description = "Name of the hub VNet"
  type        = string
}

variable "hub_resource_group_name" {
  description = "Resource group name of the hub VNet"
  type        = string
}

variable "route_table_id" {
  description = "Route table ID to associate with workload subnet (for firewall routing)"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
}

variable "environment" {
  description = "Environment name (dev, prod, etc.)"
  type        = string
}