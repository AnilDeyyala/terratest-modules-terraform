provider "azurerm" {
  features {}
}

data "azurerm_resource_group" "az-rg" {
  name     = var.resource_group_name
}

resource "azurerm_data_factory" "az-adf" {
  name                = var.azurerm_data_factory_name
  location            = data.azurerm_resource_group.az-rg.location
  resource_group_name = data.azurerm_resource_group.az-rg.name
}