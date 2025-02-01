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

variable "private_dns_zone_storage_account_blob_name" {
  type        = string
  description = "(Required) The name of the DNS Zone privatelink.blob.core.windows.net"
}

variable "private_dns_zone_key_vault_name" {
  type        = string
  description = "(Required) The name of the DNS Zone privatelink.vaultcore.azure.net"
}

variable "private_dns_zone_container_registry_name" {
  type        = string
  description = "(Required) The name of the DNS Zone privatelink.azurecr.io"
}

variable "tags" {
  type        = map(string)
  description = "(Optional) The Tags for the Azure resources."
  default     = {}
}
