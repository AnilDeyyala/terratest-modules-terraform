provider "azurerm" {
  features {}
}

locals {
  resource_group = var.rg_name 
  location       = var.location 
}

# ADD A STORAGE ACCOUNT
resource "azurerm_storage_account" "storage_account" {
  name                     = "tteststorage${var.postfix}"
  resource_group_name      = local.resource_group
  location                 = local.location
  account_kind             = var.storage_account_kind
  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_replication_type
}

# ADD A CONTAINER TO THE STORAGE 
resource "azurerm_storage_container" "container" {
  name                  = "ttest-container-${var.postfix}"
  storage_account_name  = azurerm_storage_account.storage_account.name
  container_access_type = var.container_access_type
}