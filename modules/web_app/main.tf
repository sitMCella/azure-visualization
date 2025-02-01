resource "azurerm_user_assigned_identity" "web_app_user_assigned_identity" {
  name                = "id-webapp-${var.environment}-${var.location_abbreviation}-001"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_role_assignment" "web_app_identity_role_assignment_002" {
  role_definition_name = "Storage Blob Data Reader"
  principal_id         = azurerm_user_assigned_identity.web_app_user_assigned_identity.principal_id
  principal_type       = "ServicePrincipal"
  scope                = var.storage_account_id
}

resource "azurerm_container_registry" "container_registry" {
  name                          = "crwebapplication${var.environment}${var.location_abbreviation}001"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  sku                           = "Premium"
  admin_enabled                 = true
  public_network_access_enabled = true
  dynamic "network_rule_set" {
    for_each = var.allowed_ip_address_ranges != null ? ["true"] : ["false"]
    content {
      default_action = "Deny"
      dynamic "ip_rule" {
        for_each = var.allowed_ip_address_ranges
        content {
          action   = "Allow"
          ip_range = ip_rule.value
        }
      }
      ip_rule {
        action   = "Allow"
        ip_range = "51.12.32.2/32"
      }
      ip_rule {
        action   = "Allow"
        ip_range = "51.12.32.3/32"
      }
    }
  }
  zone_redundancy_enabled = false
  anonymous_pull_enabled  = false
  tags                    = var.tags
}

resource "azurerm_private_endpoint" "private_endpoint_container_registry" {
  name                          = "pe-cr-${var.environment}-${var.location_abbreviation}-001"
  resource_group_name           = var.resource_group_name
  location                      = var.location
  subnet_id                     = var.subnet_private_endpoints_id
  custom_network_interface_name = "nic-cr-${var.environment}-${var.location_abbreviation}-001"
  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [var.private_dns_zone_container_registry_id]
  }
  private_service_connection {
    name                           = "private-service-connection"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_container_registry.container_registry.id
    subresource_names              = ["registry"]
  }
}

resource "azurerm_role_assignment" "web_app_identity_role_assignment_003" {
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.web_app_user_assigned_identity.principal_id
  principal_type       = "ServicePrincipal"
  scope                = azurerm_container_registry.container_registry.id
}

resource "null_resource" "docker_image" {
  triggers = {
    image_name         = "${azurerm_container_registry.container_registry.login_server}/frontend"
    image_tag          = "latest"
    registry_name      = azurerm_container_registry.container_registry.name
    dockerfile_path    = "${path.cwd}/frontend/Dockerfile"
    dockerfile_context = "${path.cwd}/frontend"
    dir_sha1           = sha1(join("", [for f in fileset(path.cwd, "frontend/*") : filesha1(f)]))
  }
  provisioner "local-exec" {
    command     = "./scripts/docker_build_and_push_to_acr.sh ${var.subscription_id} ${self.triggers.image_name} ${self.triggers.image_tag} ${self.triggers.registry_name} ${self.triggers.dockerfile_path} ${self.triggers.dockerfile_context}"
    interpreter = ["bash", "-c"]
  }
}

resource "azurerm_application_insights" "application_insights" {
  name                = "appi-appservice-${var.environment}-${var.location_abbreviation}-001"
  location            = var.location
  resource_group_name = var.resource_group_name
  workspace_id        = var.log_analytics_workspace_id
  application_type    = "web"
  retention_in_days   = 30
  tags                = var.tags
}

resource "azurerm_service_plan" "app_service_plan" {
  name                   = "asp-func-${var.environment}-${var.location_abbreviation}-001"
  location               = var.location
  resource_group_name    = var.resource_group_name
  os_type                = "Linux"
  sku_name               = "P1v3"
  zone_balancing_enabled = false
  tags                   = var.tags
}

# Manually configure the Virtual Network Integration property "Container image pull".
# https://github.com/hashicorp/terraform-provider-azurerm/issues/19096
resource "azurerm_linux_web_app" "app_service" {
  name                                           = "app-visualization-${var.environment}-${var.location_abbreviation}-001"
  location                                       = var.location
  resource_group_name                            = var.resource_group_name
  service_plan_id                                = azurerm_service_plan.app_service_plan.id
  public_network_access_enabled                  = true
  ftp_publish_basic_authentication_enabled       = true
  webdeploy_publish_basic_authentication_enabled = true
  virtual_network_subnet_id                      = var.subnet_vnet_integration_id
  site_config {
    application_stack {
      docker_image_name        = "frontend:latest"
      docker_registry_url      = "https://${azurerm_container_registry.container_registry.login_server}"
      docker_registry_username = azurerm_container_registry.container_registry.admin_username
      docker_registry_password = azurerm_container_registry.container_registry.admin_password
    }
    always_on                     = true
    minimum_tls_version           = "1.2"
    worker_count                  = 3
    ip_restriction_default_action = "Deny"
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
    "APPINSIGHTS_INSTRUMENTATIONKEY"                  = azurerm_application_insights.application_insights.instrumentation_key
    "APPINSIGHTS_PROFILERFEATURE_VERSION"             = "1.0.0"
    "APPINSIGHTS_SNAPSHOTFEATURE_VERSION"             = "1.0.0"
    "APPLICATIONINSIGHTS_CONNECTION_STRING"           = azurerm_application_insights.application_insights.connection_string
    "APPLICATIONINSIGHTS_ENABLESQLQUERYCOLLECTION"    = "disabled"
    "ApplicationInsightsAgent_EXTENSION_VERSION"      = "~2"
    "DISABLE_APPINSIGHTS_SDK"                         = "disabled"
    "DiagnosticServices_EXTENSION_VERSION"            = "~3"
    "IGNORE_APPINSIGHTS_SDK"                          = "disabled"
    "InstrumentationEngine_EXTENSION_VERSION"         = "disabled"
    "SnapshotDebugger_EXTENSION_VERSION"              = "disabled"
    "XDT_MicrosoftApplicationInsights_BaseExtensions" = "disabled"
    "XDT_MicrosoftApplicationInsights_Mode"           = "recommended"
    "XDT_MicrosoftApplicationInsights_PreemptSdk"     = "disabled"
  }
  sticky_settings {
    app_setting_names = [
      "APPINSIGHTS_INSTRUMENTATIONKEY",
      "APPLICATIONINSIGHTS_CONNECTION_STRING ",
      "APPINSIGHTS_PROFILERFEATURE_VERSION",
      "APPINSIGHTS_SNAPSHOTFEATURE_VERSION",
      "ApplicationInsightsAgent_EXTENSION_VERSION",
      "XDT_MicrosoftApplicationInsights_BaseExtensions",
      "DiagnosticServices_EXTENSION_VERSION",
      "InstrumentationEngine_EXTENSION_VERSION",
      "SnapshotDebugger_EXTENSION_VERSION",
      "XDT_MicrosoftApplicationInsights_Mode",
      "XDT_MicrosoftApplicationInsights_PreemptSdk",
      "APPLICATIONINSIGHTS_CONFIGURATION_CONTENT",
      "XDT_MicrosoftApplicationInsightsJava",
      "XDT_MicrosoftApplicationInsights_NodeJS",
    ]
  }
  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.web_app_user_assigned_identity.id]
  }
  tags = var.tags
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}
