resource "azurerm_resource_group" "resource_group" {
  name     = "rg-visualization-${var.environment}-${var.location_abbreviation}-001"
  location = var.location
  tags     = var.tags
}

module "dns" {
  source              = "./modules/dns"
  resource_group_name = azurerm_resource_group.resource_group.name
  tags                = var.tags
}

module "virtual_network" {
  source                                     = "./modules/virtual_network"
  resource_group_name                        = azurerm_resource_group.resource_group.name
  location                                   = var.location
  location_abbreviation                      = var.location_abbreviation
  environment                                = var.environment
  private_dns_zone_storage_account_blob_name = module.dns.private_dns_zone_storage_account_blob_name
  private_dns_zone_key_vault_name            = module.dns.private_dns_zone_key_vault_name
  private_dns_zone_container_registry_name   = module.dns.private_dns_zone_container_registry_name
  tags                                       = var.tags
}

module "key_vault" {
  source                           = "./modules/key_vault"
  resource_group_name              = azurerm_resource_group.resource_group.name
  location                         = var.location
  location_abbreviation            = var.location_abbreviation
  environment                      = var.environment
  tenant_id                        = var.tenant_id
  service_principal_account_name   = var.service_principal_account_name
  service_principal_account_secret = var.service_principal_account_secret
  allowed_ip_address_ranges        = var.allowed_ip_address_ranges
  subnet_private_endpoints_id      = module.virtual_network.subnet_private_endpoints_id
  subnet_vnet_integration_id       = module.virtual_network.subnet_vnet_integration_id
  private_dns_zone_key_vault_id    = module.dns.private_dns_zone_key_vault_id
  tags                             = var.tags
}

module "storage_account" {
  source                                   = "./modules/storage_account"
  resource_group_name                      = azurerm_resource_group.resource_group.name
  location                                 = var.location
  location_abbreviation                    = var.location_abbreviation
  environment                              = var.environment
  subnet_private_endpoints_id              = module.virtual_network.subnet_private_endpoints_id
  subnet_vnet_integration_id               = module.virtual_network.subnet_vnet_integration_id
  private_dns_zone_storage_account_blob_id = module.dns.private_dns_zone_storage_account_blob_id
  allowed_ip_addresses                     = var.allowed_ip_addresses
  tags                                     = var.tags
}

module "monitor" {
  source                = "./modules/monitor"
  resource_group_name   = azurerm_resource_group.resource_group.name
  location              = var.location
  location_abbreviation = var.location_abbreviation
  environment           = var.environment
  tags                  = var.tags
}

module "function_app" {
  source                                                           = "./modules/function_app"
  resource_group_name                                              = azurerm_resource_group.resource_group.name
  location                                                         = var.location
  location_abbreviation                                            = var.location_abbreviation
  environment                                                      = var.environment
  key_vault_id                                                     = module.key_vault.key_vault_id
  storage_account_id                                               = module.storage_account.storage_account_id
  storage_account_name                                             = module.storage_account.storage_account_name
  storage_account_primary_access_key                               = module.storage_account.storage_account_primary_access_key
  storage_container_name                                           = module.storage_account.storage_container_name
  log_analytics_workspace_id                                       = module.monitor.log_analytics_workspace_id
  allowed_ip_address_ranges                                        = var.allowed_ip_address_ranges
  subnet_vnet_integration_id                                       = module.virtual_network.subnet_vnet_integration_id
  subscription_id                                                  = var.subscription_id
  tenant_id                                                        = var.tenant_id
  key_vault_secret_service_principal_account_name_versionless_id   = module.key_vault.key_vault_secret_service_principal_account_name_versionless_id
  key_vault_secret_service_principal_account_secret_versionless_id = module.key_vault.key_vault_secret_service_principal_account_secret_versionless_id
  tags                                                             = var.tags
}

module "web_app" {
  source                                 = "./modules/web_app"
  resource_group_name                    = azurerm_resource_group.resource_group.name
  location                               = var.location
  location_abbreviation                  = var.location_abbreviation
  environment                            = var.environment
  storage_account_id                     = module.storage_account.storage_account_id
  subscription_id                        = var.subscription_id
  allowed_ip_address_ranges              = var.allowed_ip_address_ranges
  subnet_private_endpoints_id            = module.virtual_network.subnet_private_endpoints_id
  subnet_vnet_integration_id             = module.virtual_network.subnet_vnet_integration_id
  private_dns_zone_container_registry_id = module.dns.private_dns_zone_container_registry_id
  log_analytics_workspace_id             = module.monitor.log_analytics_workspace_id
  tags                                   = var.tags
}
