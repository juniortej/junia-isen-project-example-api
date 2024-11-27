output "app_service_url" {
  value = azurerm_linux_web_app.shop_app_service.default_hostname
}


