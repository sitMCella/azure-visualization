resource "azurerm_key_vault" "key_vault" {
  name                          = "kv-${var.environment}-${var.location_abbreviation}-001"
  resource_group_name           = var.resource_group_name
  location                      = var.location
  sku_name                      = "standard"
  tenant_id                     = var.tenant_id
  enable_rbac_authorization     = true
  purge_protection_enabled      = false
  public_network_access_enabled = true
  network_acls {
    default_action             = "Deny"
    bypass                     = "AzureServices"
    virtual_network_subnet_ids = [var.subnet_vnet_integration_id]
    ip_rules                   = var.allowed_ip_address_ranges
  }
  tags = var.tags
}

resource "azurerm_private_endpoint" "private_endpoint_key_vault" {
  name                          = "pe-kv-${var.environment}-${var.location_abbreviation}-001"
  resource_group_name           = var.resource_group_name
  location                      = var.location
  subnet_id                     = var.subnet_private_endpoints_id
  custom_network_interface_name = "nic-kv-${var.environment}-${var.location_abbreviation}-001"
  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [var.private_dns_zone_key_vault_id]
  }
  private_service_connection {
    name                           = "private-service-connection"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_key_vault.key_vault.id
    subresource_names              = ["vault"]
  }
}

resource "azurerm_key_vault_secret" "key_vault_secret_service_principal_account_name" {
  name         = "service-principal-account-name"
  value        = var.service_principal_account_name
  key_vault_id = azurerm_key_vault.key_vault.id
  tags         = var.tags
}

resource "azurerm_key_vault_secret" "key_vault_secret_service_principal_account_secret" {
  name         = "service-principal-account-secret"
  value        = var.service_principal_account_secret
  key_vault_id = azurerm_key_vault.key_vault.id
  tags         = var.tags
}