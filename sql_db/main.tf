provider "azurerm" {
  features {}
}

data "azurerm_resource_group" "sql_rg" {
  name     = var.resource_group_name
}

resource "random_password" "password" {
  length           = 16
  override_special = "_%@"
  min_upper        = "1"
  min_lower        = "1"
  min_numeric      = "1"
  min_special      = "1"
}

resource "azurerm_sql_server" "sqlserver" {
  name                         = "mssqlserver-${var.postfix}"
  resource_group_name          = data.azurerm_resource_group.sql_rg.name
  location                     = data.azurerm_resource_group.sql_rg.location
  version                      = "12.0"
  administrator_login          = var.sqlserver_admin_login
  administrator_login_password = random_password.password.result

  tags = {
    environment = var.tags
  }
}


resource "azurerm_sql_database" "sqldb" {
  name                = "sqldb-${var.postfix}"
  resource_group_name = data.azurerm_resource_group.sql_rg.name
  location            = data.azurerm_resource_group.sql_rg.location
  server_name         = azurerm_sql_server.sqlserver.name
  tags = {
    environment = var.tags
  }
}