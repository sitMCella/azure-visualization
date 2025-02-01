output "private_dns_zone_storage_account_blob_id" {
  description = "The ID of the DNS Zone privatelink.blob.core.windows.net"
  value       = azurerm_private_dns_zone.private_dns_zone_storage_account_blob.id
}

output "private_dns_zone_storage_account_blob_name" {
  description = "The name of the DNS Zone privatelink.blob.core.windows.net"
  value       = azurerm_private_dns_zone.private_dns_zone_storage_account_blob.name
}

output "private_dns_zone_key_vault_id" {
  description = "The ID of the DNS Zone privatelink.vaultcore.azure.net"
  value       = azurerm_private_dns_zone.private_dns_zone_key_vault.id
}

output "private_dns_zone_key_vault_name" {
  description = "The name of the DNS Zone privatelink.vaultcore.azure.net"
  value       = azurerm_private_dns_zone.private_dns_zone_key_vault.name
}

output "private_dns_zone_container_registry_id" {
  description = "The ID of the DNS Zone privatelink.azurecr.io"
  value       = azurerm_private_dns_zone.private_dns_zone_container_registry.id
}

output "private_dns_zone_container_registry_name" {
  description = "The name of the DNS Zone privatelink.azurecr.io"
  value       = azurerm_private_dns_zone.private_dns_zone_container_registry.name
}
