output "app_service_url" {
  description = "The default URL of the App Service"
  value       = azurerm_app_service.module_example.default_site_hostname
}
