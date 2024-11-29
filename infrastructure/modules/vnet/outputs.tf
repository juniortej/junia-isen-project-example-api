output "vnet_id" {
  description = "The ID of the Virtual Network"
  value       = azurerm_virtual_network.main.id
}

output "vnet_name" {
  description = "The name of the Virtual Network"
  value       = azurerm_virtual_network.main.name
}

output "db_subnet_id" {
  description = "The ID of the Database Subnet"
  value       = azurerm_subnet.db_subnet.id
}

output "db_subnet_name" {
  description = "The name of the Database Subnet"
  value       = azurerm_subnet.db_subnet.name
}

output "app_subnet_id" {
  description = "The ID of the Application Subnet"
  value       = azurerm_subnet.app_subnet.id
}

output "app_subnet_name" {
  description = "The name of the Application Subnet"
  value       = azurerm_subnet.app_subnet.name
}

output "db_nsg_id" {
  description = "The ID of the Database Network Security Group"
  value       = azurerm_network_security_group.db_nsg.id
}

output "app_nsg_id" {
  description = "The ID of the Application Network Security Group"
  value       = azurerm_network_security_group.app_nsg.id
}