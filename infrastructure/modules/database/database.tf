resource "random_string" "unique_suffix" {
  length  = 6
  upper   = false
  special = false
}

resource "azurerm_postgresql_flexible_server" "main" {
  name                          = "${var.project_name}-postgresql-${random_string.unique_suffix.result}"
  resource_group_name           = var.resource_group_name
  location                      = var.location
  version                       = "14"
  administrator_login           = var.admin_username
  administrator_password        = var.admin_password
  delegated_subnet_id           = var.subnet_id
  private_dns_zone_id           = var.private_dns_zone_id
  public_network_access_enabled = false 

  sku_name    = "GP_Standard_D2s_v3"
  storage_mb  = 32768
  storage_tier = "P4"

  tags = {
    environment = var.environment
  }
}

resource "azurerm_postgresql_flexible_server_configuration" "disable_ssl" {
  name      = "ssl_enforcement"
  server_id = azurerm_postgresql_flexible_server.main.id
  value     = "Disabled"
}

resource "azurerm_postgresql_flexible_server_database" "main" {
  name      = "app_db"
  server_id = azurerm_postgresql_flexible_server.main.id
  charset   = "UTF8"
  collation = "en_US.utf8"
}
