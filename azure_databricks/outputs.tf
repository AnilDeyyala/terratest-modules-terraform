output "resource_group_name" {
  value = data.azurerm_resource_group.rg.name 
}

output "data_bricks_name" {
  value = azurerm_databricks_workspace.adb.name
}