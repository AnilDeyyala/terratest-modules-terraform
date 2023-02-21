output "resource_group_name" {
  value = data.azurerm_resource_group.az-rg.name
}

output "data_factory_name" {
  value = azurerm_data_factory.az-adf.name
}

output "data_factory_location" {
  value = azurerm_data_factory.az-adf.location
}
