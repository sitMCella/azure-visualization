resource "azurerm_virtual_network" "virtual_network" {
  name                = "vnet-${var.environment}-${var.location_abbreviation}-001"
  resource_group_name = var.resource_group_name
  address_space       = ["10.0.0.0/20"]
  location            = var.location
  tags                = var.tags
}

resource "azurerm_subnet" "subnet_private_endpoints" {
  name                 = "snet-private-endpoints-${var.environment}-${var.location_abbreviation}-001"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_subnet" "subnet_vnet_integration" {
  name                 = "snet-vnet-integration-${var.environment}-${var.location_abbreviation}-001"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes     = ["10.0.1.0/24"]
  delegation {
    name = "delegation-server-farms"
    service_delegation {
      name = "Microsoft.Web/serverFarms"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/action"
      ]
    }
  }
  service_endpoints = ["Microsoft.Storage", "Microsoft.KeyVault"]
}

resource "azurerm_private_dns_zone_virtual_network_link" "private_dns_zone_virtual_network_link_blob" {
  name                  = "dnslink-blob-${var.environment}-${var.location_abbreviation}-001"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = var.private_dns_zone_storage_account_blob_name
  virtual_network_id    = azurerm_virtual_network.virtual_network.id
  tags                  = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "private_dns_zone_virtual_network_link_key_vault" {
  name                  = "dnslink-key-vault-${var.environment}-${var.location_abbreviation}-001"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = var.private_dns_zone_key_vault_name
  virtual_network_id    = azurerm_virtual_network.virtual_network.id
  tags                  = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "private_dns_zone_virtual_network_link_container_registry" {
  name                  = "dnslink-container-registry-${var.environment}-${var.location_abbreviation}-001"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = var.private_dns_zone_container_registry_name
  virtual_network_id    = azurerm_virtual_network.virtual_network.id
  tags                  = var.tags
}