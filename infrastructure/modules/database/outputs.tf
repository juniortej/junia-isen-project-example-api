output "db_host" {
  description = "Database host: "
  value       = azurerm_postgresql_flexible_server.database_server.fqdn
}

output "db_port" {
  description = "Database port: "
  value       = 5432
}

output "db_name" {
  description = "Database name: "
  value       = azurerm_postgresql_flexible_server_database.database.name
}

output "db_admin_username" {
  description = "Admin username: "
  value       = azurerm_postgresql_flexible_server.database_server.administrator_login
  sensitive   = true
}

output "db_admin_password" {
  description = "Admin password: "
  value       = var.database_admin_password
  sensitive   = true
}