output "app_service_url" {
  description = "URL of the App Service"
  value       = azurerm_app_service.app.default_site_hostname
}
output "acr_login_server" {
  description = "Login server URL for the Azure Container Registry"
  value       = azurerm_container_registry.acr.login_server
}
