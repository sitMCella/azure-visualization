output "storage_account_id" {
  description = "The ID of the Storage Account"
  value       = azurerm_storage_account.storage_account.id
}

output "storage_account_name" {
  description = "The name of the Storage Account"
  value       = azurerm_storage_account.storage_account.name
}

output "storage_account_primary_access_key" {
  description = "The Primary Access Key of the Storage Account"
  value       = azurerm_storage_account.storage_account.primary_access_key
}

output "storage_container_name" {
  description = "The name of the container"
  value       = azurerm_storage_container.container.name
}
