output "postgresql_server_name" {
  description = "The name of the PostgreSQL Flexible Server"
  value       = azurerm_postgresql_flexible_server.main.name
}

output "postgresql_fqdn" {
  description = "The Fully Qualified Domain Name of the PostgreSQL Flexible Server"
  value       = azurerm_postgresql_flexible_server.main.fqdn
}
