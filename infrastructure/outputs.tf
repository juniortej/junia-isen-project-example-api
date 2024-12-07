output "resource_group_name" {
  description = "The name of the Resource Group"
  value       = azurerm_resource_group.main.name
}

output "vnet_id" {
  description = "The ID of the Virtual Network"
  value       = module.vnet.vnet_id
}

output "vnet_name" {
  description = "The name of the Virtual Network"
  value       = module.vnet.vnet_name
}

output "db_subnet_id" {
  description = "The ID of the Database Subnet"
  value       = module.vnet.db_subnet_id
}

output "db_subnet_name" {
  description = "The name of the Database Subnet"
  value       = module.vnet.db_subnet_name
}

output "postgresql_server_name" {
  description = "The name of the PostgreSQL server"
  value       = module.database.postgresql_server_name
}

output "postgresql_server_fqdn" {
  description = "The FQDN of the PostgreSQL server"
  value       = module.database.postgresql_server_fqdn
}

output "postgresql_database_name" {
  description = "The name of the PostgreSQL database"
  value       = module.database.postgresql_database_name
}

output "postgresql_administrator_login" {
  description = "The administrator login for the PostgreSQL server"
  value       = module.database.postgresql_administrator_login
}

output "vpn_gateway_public_ip" {
  description = "The public IP address of the VPN Gateway"
  value       = module.vpn_gateway.vpn_gateway_public_ip
}
