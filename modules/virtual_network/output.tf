output "subnet_private_endpoints_id" {
  description = "The ID of the private endpoints subnet"
  value       = azurerm_subnet.subnet_private_endpoints.id
}

output "subnet_vnet_integration_id" {
  description = "The ID of the vnet integration subnet"
  value       = azurerm_subnet.subnet_vnet_integration.id
}
