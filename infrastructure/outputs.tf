output "app_service_url" {
  description = "URL of the deployed Azure App Service"
  value       = module.app_service.app_service_url
}

output "sql_server_fqdn" {
  description = "Fully qualified domain name of the SQL Server"
  value       = module.database.sql_server_fqdn
}

output "storage_account_name" {
  description = "Name of the Azure Storage Account"
  value       = module.storage.storage_account_name
}

output "acr_login_server" {
  description = "Login server URL for the Azure Container Registry"
  value       = azurerm_container_registry.acr.login_server
}
