output "app_service_id" {
  description = "The ID of the App Service."
  value       = azurerm_linux_web_app.main.id
}

output "app_service_default_hostname" {
  description = "The default hostname of the App Service."
  value       = azurerm_linux_web_app.main.default_hostname
}

output "app_service_url" {
  description = "The URL of the App Service."
  value       = "https://${azurerm_linux_web_app.main.default_hostname}"
}
