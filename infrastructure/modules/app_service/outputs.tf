output "url" {
    description = "Url to connect to the app service: "
    value = "https://${azurerm_linux_web_app.app_service.default_hostname}/"
}

output "principal_id" {
  value = azurerm_linux_web_app.app_service.identity[0].principal_id
  description = "Principal ID of the API App service's managed identity"
}