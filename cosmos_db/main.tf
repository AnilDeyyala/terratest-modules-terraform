
provider "azurerm" {
  features {}
}


# ---------------------------------------------------------------------------------------------------------------------
# DEPLOY A RESOURCE GROUP
# ---------------------------------------------------------------------------------------------------------------------

data "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
}

# ---------------------------------------------------------------------------------------------------------------------
# DEPLOY A COSMOSDB ACCOUNT
# ---------------------------------------------------------------------------------------------------------------------

resource "azurerm_cosmosdb_account" "test" {
  name                = "terratest-${var.postfix}"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"

  consistency_policy {
    consistency_level       = "Session"
    max_interval_in_seconds = 5
    max_staleness_prefix    = 100
  }

  geo_location {
    location          = data.azurerm_resource_group.rg.location
    failover_priority = 0
  }
}

resource "azurerm_cosmosdb_sql_database" "testdb" {
  name                = "testdb"
  throughput          = var.throughput
  resource_group_name = data.azurerm_resource_group.rg.name
  account_name        = azurerm_cosmosdb_account.test.name
}

resource "azurerm_cosmosdb_sql_container" "container1" {
  name                = "test-container-1"
  throughput          = var.throughput
  partition_key_path  = "/key1"
  resource_group_name = azurerm_cosmosdb_account.test.resource_group_name
  account_name        = azurerm_cosmosdb_account.test.name
  database_name       = azurerm_cosmosdb_sql_database.testdb.name
}

resource "azurerm_cosmosdb_sql_container" "container2" {
  name                = "test-container-2"
  partition_key_path  = "/key2"
  resource_group_name = azurerm_cosmosdb_account.test.resource_group_name
  account_name        = azurerm_cosmosdb_account.test.name
  database_name       = azurerm_cosmosdb_sql_database.testdb.name
}

resource "azurerm_cosmosdb_sql_container" "container3" {
  name                = "test-container-3"
  partition_key_path  = "/key3"
  resource_group_name = azurerm_cosmosdb_account.test.resource_group_name
  account_name        = azurerm_cosmosdb_account.test.name
  database_name       = azurerm_cosmosdb_sql_database.testdb.name
}