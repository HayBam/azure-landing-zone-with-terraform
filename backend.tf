terraform {
  backend "azurerm" {
    resource_group_name  = "landing-zone-terraform-rg"
    storage_account_name = "storageterraformstateayo"
    container_name       = "tfstate"
    key                  = "landing-zone.tfstate"
  }
}