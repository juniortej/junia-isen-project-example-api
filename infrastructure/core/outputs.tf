# infrastructure/core/outputs.tf

output "resource_group_name" {
  description = "The name of the Resource Group."
  value       = azurerm_resource_group.base.name
}

# Reference database module outputs
output "postgresql_server_name" {
  description = "The name of the PostgreSQL Flexible Server"
  value       = module.database.postgresql_server_name
}

output "postgresql_server_fqdn" {
  description = "The FQDN of the PostgreSQL Flexible Server"
  value       = module.database.postgresql_server_fqdn
}

output "postgresql_database_name" {
  description = "The name of the PostgreSQL Database"
  value       = module.database.postgresql_database_name
}

output "postgresql_administrator_login" {
  description = "The administrator login for the PostgreSQL server"
  value       = module.database.postgresql_administrator_login
}

output "postgresql_admin_password" {
  description = "The administrator password for the PostgreSQL server"
  value       = module.database.postgresql_admin_password
  sensitive   = true
}

output "database_password" {
  description = "The password for the PostgreSQL database"
  value       = module.database.database_password
  sensitive   = true
}

output "vpn_gateway_public_ip" {
  description = "The public IP address of the VPN Gateway"
  value       = module.vpn_gateway.vpn_gateway_public_ip
}
