output "resource_group_name" {
  value = local.resource_group
}

output "storage_account_name" {
  value = azurerm_storage_account.storage_account.name
}

output "storage_account_account_tier" {
  value = azurerm_storage_account.storage_account.account_tier
}

output "storage_account_account_kind" {
  value = azurerm_storage_account.storage_account.account_kind
}

output "storage_container_name" {
  value = azurerm_storage_container.container.name
}