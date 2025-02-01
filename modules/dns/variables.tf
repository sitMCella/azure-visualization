variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the Resource Group."
}

variable "tags" {
  type        = map(string)
  description = "(Optional) The Tags for the Azure resources."
  default     = {}
}
