output "url" {
    description = "Url to connect to the app service: "
    value = "https://${azurerm_linux_web_app.app_service.default_hostname}/"
}