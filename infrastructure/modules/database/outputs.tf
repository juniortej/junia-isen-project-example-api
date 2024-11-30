# modules/database/outputs.tf

output "postgresql_server_name" {
  description = "The name of the PostgreSQL Flexible Server"
  value       = azurerm_postgresql_flexible_server.main.name
}

output "postgresql_server_fqdn" {
  description = "The FQDN of the PostgreSQL Flexible Server"
  value       = azurerm_postgresql_flexible_server.main.fqdn
}

output "postgresql_database_name" {
  description = "The name of the PostgreSQL Database"
  value       = azurerm_postgresql_flexible_server_database.main.name
}

output "postgresql_administrator_login" {
  description = "The administrator login for the PostgreSQL server"
  value       = azurerm_postgresql_flexible_server.main.administrator_login
}
