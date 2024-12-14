output "vnet_id" {
  value       = azurerm_virtual_network.vnet.id
  description = "The ID of the Azure Virtual Network (VNet)."
}

output "private_dns_zone_id" {
  value       = azurerm_private_dns_zone.postgresql_dns_zone.id
  description = "The ID of the private DNS zone associated with the PostgreSQL Flexible Server."
}

output "app_service_subnet_id" {
  value       = azurerm_subnet.app_service_subnet.id
  description = "The ID of the subnet allocated for the App Service."
}

output "postgresql_subnet_id" {
  value       = azurerm_subnet.postgresql_subnet.id
  description = "The ID of the subnet allocated for the PostgreSQL Flexible Server."
}