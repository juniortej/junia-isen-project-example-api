resource "azurerm_private_dns_zone" "private_dns_zone" {
  name                = var.dns_zone_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "private_dns_zone_virtual_network_link" {
  name                  = var.dns_zone_link_name
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_zone.name
  virtual_network_id    = var.vnet_id
}

resource "azurerm_postgresql_flexible_server" "database_server" {
  name                = var.server_name
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location

  delegated_subnet_id = var.database_subnet_id
  public_network_access_enabled = false
  private_dns_zone_id = azurerm_private_dns_zone.private_dns_zone.id

  administrator_login = var.database_admin_username
  administrator_password = var.database_admin_password

  sku_name            = "B_Standard_B1ms"
  storage_mb          = "32768"
  storage_tier        = "P4"
  version             = "16"
  zone                = "1"
  depends_on          = [azurerm_private_dns_zone_virtual_network_link.private_dns_zone_virtual_network_link]
}

resource "azurerm_postgresql_flexible_server_database" "database" {
  name                = var.database_name
  server_id           = azurerm_postgresql_flexible_server.database_server.id
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "allow_webapp" {
  name                = "AllowWebApp"
  server_id           = azurerm_postgresql_flexible_server.database_server.id
  start_ip_address    = "192.168.2.0"
  end_ip_address      = "192.168.2.255"
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "allow_client" {
  name                = "AllowClient"
  server_id           = azurerm_postgresql_flexible_server.database_server.id
  start_ip_address    = var.ip_authorized
  end_ip_address      = var.ip_authorized
}
