variable "location" {
  description = "Primary Azure region for all resources"
  type        = string
  default     = "canadacentral"
}

variable "root_management_group_name" {
  description = "Display name for the root management group"
  type        = string
  default     = "Ayo-Enterprise"
}

variable "hub_vnet_address_space" {
  description = "Address space for the hub virtual network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "dev_spoke_address_space" {
  description = "Address space for the dev spoke virtual network"
  type        = list(string)
  default     = ["10.1.0.0/16"]
}

variable "prod_spoke_address_space" {
  description = "Address space for the prod spoke virtual network"
  type        = list(string)
  default     = ["10.2.0.0/16"]
}

variable "tags" {
  description = "Common tags applied to all resources"
  type        = map(string)
  default = {
    Project     = "Azure-Landing-Zone-With-Terraform"
    Environment = "Lab"
    ManagedBy   = "Terraform"
    Owner       = "Ayo"
  }
}