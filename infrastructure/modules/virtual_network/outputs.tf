output "virtual_network_name" {
  description = "Virtual Network Name: "
  value       = azurerm_virtual_network.virtual_network.name
}

output "virtual_network_address_space" {
  description = "Virtual Network Address Space: "
  value       = azurerm_virtual_network.virtual_network.address_space
}

output "virtual_network_id" {
  description = "Virtual Network ID: "
  value       = azurerm_virtual_network.virtual_network.id
}