variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the Resource Group."
}

variable "location" {
  type        = string
  description = "(Required) The location of the Azure resources (e.g. westeurope)."
}

variable "location_abbreviation" {
  type        = string
  description = "(Required) The location abbreviation (e.g. weu)."
}

variable "environment" {
  type        = string
  description = "(Required) The environment name (e.g. test)."
}

variable "key_vault_id" {
  type        = string
  description = "(Required) The ID of the Key Vault."
}

variable "storage_account_id" {
  type        = string
  description = "(Required) The ID of the Storage Account."
}

variable "storage_account_name" {
  type        = string
  description = "(Required) The name of the Storage Account."
}

variable "storage_account_primary_access_key" {
  type        = string
  description = "(Required) The Primary Access Key of the Storage Account."
}

variable "storage_container_name" {
  type        = string
  description = "(Required) The name of the Storage Account container."
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "(Required) The ID of the Log Analytics workspace."
}

variable "allowed_ip_address_ranges" {
  type        = list(string)
  description = "(Optional) The external IP address ranges allowed to access the Azure resources."
  default     = []
}

variable "subnet_vnet_integration_id" {
  type        = string
  description = "(Required) The ID of the vnet integration subnet."
}

variable "subscription_id" {
  type        = string
  description = "(Required) The Subscription ID."
}

variable "tenant_id" {
  type        = string
  description = "(Required) The Azure Tenant ID."
}

variable "key_vault_secret_service_principal_account_name_versionless_id" {
  type        = string
  description = "(Required) The Versionless ID of the Key Vault secret principal account name."
}

variable "key_vault_secret_service_principal_account_secret_versionless_id" {
  type        = string
  description = "(Required) The Versionless ID of the Key Vault secret principal account secret."
}

variable "tags" {
  type        = map(string)
  description = "(Optional) The Tags for the Azure resources."
  default     = {}
}
