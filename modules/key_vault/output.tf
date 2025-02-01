output "key_vault_id" {
  description = "The ID of the Key Vault"
  value       = azurerm_key_vault.key_vault.id
}

output "key_vault_secret_service_principal_account_name_versionless_id" {
  description = "The Versionless ID of the Key Vault secret principal account name"
  value       = azurerm_key_vault_secret.key_vault_secret_service_principal_account_name.versionless_id
}

output "key_vault_secret_service_principal_account_secret_versionless_id" {
  description = "The Versionless ID of the Key Vault secret principal account secret"
  value       = azurerm_key_vault_secret.key_vault_secret_service_principal_account_secret.versionless_id
}
