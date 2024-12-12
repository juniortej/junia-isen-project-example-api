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

output "python_app_subnet_name" {
  description = "Python App Subnet Name: "
  value       = azurerm_subnet.python_app_subnet.name
}

output "python_app_subnet_address_space" {
  description = "Python App Subnet Address Space: "
  value       = azurerm_subnet.python_app_subnet.address_prefixes
}

output "python_app_subnet_id" {
  description = "Python App Subnet ID: "
  value       = azurerm_subnet.python_app_subnet.id
}

output "application_gateway_subnet_name" {
  description = "Application Gateway Subnet Name: "
  value       = azurerm_subnet.application_gateway_subnet.name
}

output "application_gateway_subnet_address_space" {
  description = "Application Gateway Subnet Address Space: "
  value       = azurerm_subnet.application_gateway_subnet.address_prefixes
}

output "application_gateway_subnet_id" {
  description = "Application Gateway Subnet ID: "
  value       = azurerm_subnet.application_gateway_subnet.id
}