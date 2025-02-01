resource "azurerm_storage_account" "storage_account" {
  name                          = "stdata${var.environment}${var.location_abbreviation}001"
  resource_group_name           = var.resource_group_name
  location                      = var.location
  account_tier                  = "Standard"
  account_kind                  = "StorageV2"
  account_replication_type      = "LRS"
  access_tier                   = "Hot"
  https_traffic_only_enabled    = true
  min_tls_version               = "TLS1_2"
  shared_access_key_enabled     = true
  public_network_access_enabled = true
  network_rules {
    default_action             = "Deny"
    virtual_network_subnet_ids = [var.subnet_vnet_integration_id]
    ip_rules                   = var.allowed_ip_addresses
  }
  blob_properties {
    delete_retention_policy {
      days = 14
    }
    container_delete_retention_policy {
      days = 7
    }
    cors_rule {
      allowed_headers    = ["*"]
      allowed_methods    = ["GET", "OPTIONS", "HEAD"]
      allowed_origins    = ["*"]
      exposed_headers    = ["*"]
      max_age_in_seconds = 1800
    }
  }
  tags = var.tags
}

resource "azurerm_storage_container" "container" {
  name                  = "data"
  storage_account_id    = azurerm_storage_account.storage_account.id
  container_access_type = "private"
}

resource "azurerm_private_endpoint" "private_endpoint_storage_account" {
  name                          = "pe-st-${var.environment}-${var.location_abbreviation}-001"
  resource_group_name           = var.resource_group_name
  location                      = var.location
  subnet_id                     = var.subnet_private_endpoints_id
  custom_network_interface_name = "nic-st-${var.environment}-${var.location_abbreviation}-001"
  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [var.private_dns_zone_storage_account_blob_id]
  }
  private_service_connection {
    name                           = "private-service-connection"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_storage_account.storage_account.id
    subresource_names              = ["blob"]
  }
}