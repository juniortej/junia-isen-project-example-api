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

output "database_subnet_name" {
  description = "Database Subnet Name: "
  value       = azurerm_subnet.database_subnet.name
}

output "database_subnet_address_space" {
  description = "Database Subnet Address Space: "
  value       = azurerm_subnet.database_subnet.address_prefixes
}

output "database_subnet_id" {
  description = "Database Subnet ID: "
  value       = azurerm_subnet.database_subnet.id
}