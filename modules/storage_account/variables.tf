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

variable "subnet_private_endpoints_id" {
  type        = string
  description = "(Required) The ID of the private endpoints subnet."
}

variable "subnet_vnet_integration_id" {
  type        = string
  description = "(Required) The ID of the vnet integration subnet."
}

variable "private_dns_zone_storage_account_blob_id" {
  type        = string
  description = "(Required) The ID of the DNS Zone privatelink.blob.core.windows.net."
}

variable "allowed_ip_addresses" {
  type        = list(string)
  description = "(Optional) The external IP addresses allowed to access the Azure resources."
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "(Optional) The Tags for the Azure resources."
  default     = {}
}
