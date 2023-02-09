provider "azurerm" {
  features {}
}


data "azurerm_resource_group" "rg" {
  name     = var.rg_name 
}

resource "azurerm_container_registry" "acr" {
  name                = "acr${var.postfix}"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  sku           = var.sku
  admin_enabled = true

  tags = {
    Environment = "Development"
  }
}