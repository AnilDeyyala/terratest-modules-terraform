provider "azurerm" {
  features {}
}

data "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
}

resource "azurerm_databricks_workspace" "adb" {
  name                = var.data_bricks_name
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  sku                 = "standard"

  tags = {
    Environment = "Production"
  }
}