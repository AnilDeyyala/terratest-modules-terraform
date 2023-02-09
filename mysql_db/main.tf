provider "azurerm" {
  features {}
}


data "azurerm_resource_group" "mysql_rg" {
  name     = var.resource_group_name
}

# ---------------------------------------------------------------------------------------------------------------------
# DEPLOY AZURE MySQL SERVER
# ---------------------------------------------------------------------------------------------------------------------

# Random password is used as an example to simplify the deployment and improve the security of the database.
# This is not as a production recommendation as the password is stored in the Terraform state file.
resource "random_password" "password" {
  length           = 16
  override_special = "_%@"
  min_upper        = "1"
  min_lower        = "1"
  min_numeric      = "1"
  min_special      = "1"
}

resource "azurerm_mysql_server" "mysqlserver" {
  name                = "mysqlserver-${var.postfix}"
  location            = data.azurerm_resource_group.mysql_rg.location
  resource_group_name = data.azurerm_resource_group.mysql_rg.name

  administrator_login          = var.mysqlserver_admin_login
  administrator_login_password = random_password.password.result

  sku_name   = var.mysqlserver_sku_name
  storage_mb = var.mysqlserver_storage_mb
  version    = "5.7"

  auto_grow_enabled                 = true
  geo_redundant_backup_enabled      = false
  infrastructure_encryption_enabled = true
  backup_retention_days             = 7
  public_network_access_enabled     = false
  ssl_enforcement_enabled           = true
  ssl_minimal_tls_version_enforced  = "TLS1_2"
}

# ---------------------------------------------------------------------------------------------------------------------
# DEPLOY AZURE MySQL DATABASE
# ---------------------------------------------------------------------------------------------------------------------

resource "azurerm_mysql_database" "mysqldb" {
  name                = "mysqldb-${var.postfix}"
  resource_group_name = data.azurerm_resource_group.mysql_rg.name
  server_name         = azurerm_mysql_server.mysqlserver.name
  charset             = var.mysqldb_charset
  collation           = var.mysqldb_collation
}