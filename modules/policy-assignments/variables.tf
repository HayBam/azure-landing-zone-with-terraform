variable "root_mg_id" {
  description = "ID of the root management group"
  type        = string
}

variable "landing_zones_mg_id" {
  description = "ID of the Landing Zones management group"
  type        = string
}

variable "prod_mg_id" {
  description = "ID of the Prod management group"
  type        = string
}

variable "allowed_locations" {
  description = "List of allowed Azure regions"
  type        = list(string)
  default     = ["canadacentral", "canadaeast"]
}