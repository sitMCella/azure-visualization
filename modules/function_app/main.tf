resource "azurerm_user_assigned_identity" "function_app_user_assigned_identity" {
  name                = "id-func-${var.environment}-${var.location_abbreviation}-001"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_role_assignment" "function_app_identity_role_assignment_001" {
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.function_app_user_assigned_identity.principal_id
  principal_type       = "ServicePrincipal"
  scope                = var.key_vault_id
}

resource "azurerm_role_assignment" "function_app_identity_role_assignment_002" {
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = azurerm_user_assigned_identity.function_app_user_assigned_identity.principal_id
  principal_type       = "ServicePrincipal"
  scope                = var.storage_account_id
}

resource "azurerm_role_assignment" "function_app_identity_role_assignment_003" {
  role_definition_name = "Storage Account Contributor"
  principal_id         = azurerm_user_assigned_identity.function_app_user_assigned_identity.principal_id
  principal_type       = "ServicePrincipal"
  scope                = var.storage_account_id
}

data "archive_file" "function_package_hash" {
  type        = "zip"
  source_dir  = "${path.cwd}/modules/function_app/function"
  output_path = "function.zip"
}

data "archive_file" "function_package" {
  type        = "zip"
  source_dir  = "${path.cwd}/modules/function_app/function"
  output_path = "function-${data.archive_file.function_package_hash.output_sha256}.zip"
}

resource "azurerm_application_insights" "function_app_application_insights" {
  name                = "appi-func-${var.environment}-${var.location_abbreviation}-001"
  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = "web"
  workspace_id        = var.log_analytics_workspace_id
  tags                = var.tags
}

resource "random_string" "random_function_app_name" {
  length  = 7
  special = false
  upper   = false
}

resource "azurerm_service_plan" "app_service_plan" {
  name                   = "asp-func-${var.environment}-${var.location_abbreviation}-001"
  location               = var.location
  resource_group_name    = var.resource_group_name
  os_type                = "Windows"
  sku_name               = "P1v3"
  zone_balancing_enabled = false
  tags                   = var.tags
}

resource "azurerm_windows_function_app" "function_app" {
  name                          = "func-${random_string.random_function_app_name.result}-${var.environment}-${var.location_abbreviation}-001"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  service_plan_id               = azurerm_service_plan.app_service_plan.id
  storage_account_name          = var.storage_account_name
  storage_account_access_key    = var.storage_account_primary_access_key
  virtual_network_subnet_id     = var.subnet_vnet_integration_id
  public_network_access_enabled = true
  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.function_app_user_assigned_identity.id]
  }
  key_vault_reference_identity_id = azurerm_user_assigned_identity.function_app_user_assigned_identity.id
  site_config {
    always_on = false
    application_stack {
      powershell_core_version = "7.4"
    }
    application_insights_connection_string = azurerm_application_insights.function_app_application_insights.connection_string
    application_insights_key               = azurerm_application_insights.function_app_application_insights.instrumentation_key
    ip_restriction_default_action          = "Deny"
    dynamic "ip_restriction" {
      for_each = var.allowed_ip_address_ranges
      iterator = allowed_ip_address_range
      content {
        action     = "Allow"
        ip_address = allowed_ip_address_range.value
      }
    }
  }
  app_settings = {
    WEBSITE_CONTENTOVERVNET      = "1"
    SubscriptionId               = var.subscription_id
    TenantId                     = var.tenant_id
    ApplicationId                = "@Microsoft.KeyVault(SecretUri=${var.key_vault_secret_service_principal_account_name_versionless_id})"
    ClientSecret                 = "@Microsoft.KeyVault(SecretUri=${var.key_vault_secret_service_principal_account_secret_versionless_id})"
    UserAssignedIdentityClientId = azurerm_user_assigned_identity.function_app_user_assigned_identity.client_id
    StorageResourceGroupName     = var.resource_group_name
    StorageName                  = var.storage_account_name
    StorageContainerName         = var.storage_container_name
  }
  zip_deploy_file = data.archive_file.function_package.output_path
  tags            = var.tags
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}
