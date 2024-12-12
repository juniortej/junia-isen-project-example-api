output "public_ip_address" {
  description = "Public IP address of the application gateway: "
  value       = azurerm_public_ip.app_gateway_public_ip.ip_address
}