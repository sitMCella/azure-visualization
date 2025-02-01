variable "service_principal_account_name" {
  type        = string
  description = "(Required) Name of the Service Principal Account."
}

variable "service_principal_account_secret" {
  type        = string
  description = "(Required) Secret of the Service Principal Account."
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

variable "subscription_id" {
  type        = string
  description = "(Required) The Subscription ID."
}

variable "tenant_id" {
  type        = string
  description = "(Required) The Azure Tenant ID."
}

variable "allowed_ip_address_ranges" {
  type        = list(string)
  description = "(Optional) The external IP address ranges allowed to access the Azure resources."
  default     = []
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
