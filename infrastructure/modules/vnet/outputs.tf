# modules/vnet/outputs.tf

output "vnet_id" {
  description = "The ID of the Virtual Network"
  value       = azurerm_virtual_network.main.id
}

output "vnet_name" {
  description = "The name of the Virtual Network"
  value       = azurerm_virtual_network.main.name
}

output "vnet_address_space" {
  description = "The address space of the Virtual Network"
  value       = azurerm_virtual_network.main.address_space
}

output "db_subnet_id" {
  description = "The ID of the Database Subnet"
  value       = azurerm_subnet.db_subnet.id
}

output "db_subnet_name" {
  description = "The name of the Database Subnet"
  value       = azurerm_subnet.db_subnet.name
}

output "gateway_subnet_id" {
  description = "The ID of the Gateway Subnet"
  value       = azurerm_subnet.gateway_subnet.id
}
