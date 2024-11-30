# modules/vpn_gateway/outputs.tf

output "vpn_gateway_public_ip" {
  description = "The public IP address of the VPN Gateway"
  value       = azurerm_public_ip.vpn_gateway_ip.ip_address
}

output "vpn_gateway_id" {
  description = "The ID of the VPN Gateway"
  value       = azurerm_virtual_network_gateway.vpn_gateway.id
}
