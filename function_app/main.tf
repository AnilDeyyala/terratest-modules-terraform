provider "azurerm" {
  features {}
}

data "azurerm_resource_group" "app_rg" {
  name     = var.resource_group_name
}

resource "azurerm_storage_account" "storage" {
  name                     = "storageaccount${var.postfix}"
  resource_group_name      = data.azurerm_resource_group.app_rg.name
  location                 = data.azurerm_resource_group.app_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_app_service_plan" "app_service_plan" {
  name                = "appservice-plan-${var.postfix}"
  location            = data.azurerm_resource_group.app_rg.location
  resource_group_name = data.azurerm_resource_group.app_rg.name
  kind                = "FunctionApp"

  sku {
    tier = "Standard"
    size = "S1"
  }
}


resource "azurerm_application_insights" "application_insights" {
  name                = "appinsights-${var.postfix}"
  location            = data.azurerm_resource_group.app_rg.location
  resource_group_name = data.azurerm_resource_group.app_rg.name
  application_type    = "web"
}

resource "azurerm_function_app" "function_app" {
  name                       = "functionapp-${var.postfix}"
  location                   = data.azurerm_resource_group.app_rg.location
  resource_group_name        = data.azurerm_resource_group.app_rg.name
  app_service_plan_id        = azurerm_app_service_plan.app_service_plan.id
  storage_account_name       = azurerm_storage_account.storage.name
  storage_account_access_key = azurerm_storage_account.storage.primary_access_key


  app_settings = {
    "APPINSIGHTS_INSTRUMENTATIONKEY"        = azurerm_application_insights.application_insights.instrumentation_key
    "APPLICATIONINSIGHTS_CONNECTION_STRING" = "InstrumentationKey=${azurerm_application_insights.application_insights.instrumentation_key}"
  }
}