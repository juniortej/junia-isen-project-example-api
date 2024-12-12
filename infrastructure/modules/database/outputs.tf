output "sql_server_fqdn" {
  description = "Fully qualified domain name of the SQL Server"
  value       = azurerm_postgresql_server.postgresql_server
}
output "database_name" {
  value = azurerm_postgresql_database.postgresql_database.name
}