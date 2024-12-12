resource "azurerm_postgresql_server" "postgresql_server" {
  name                = var.sql_server_name
  location            = var.location
  resource_group_name = var.resource_group_name
  administrator_login = var.admin_username
  administrator_login_password = var.admin_password
  sku_name            = "B_Gen5_1"
  storage_mb          = 5120
  version             = "11"
  ssl_enforcement_enabled = true
}

resource "azurerm_postgresql_database" "postgresql_database" {
  name                = var.sql_database_name
  resource_group_name = var.resource_group_name
  server_name         = azurerm_postgresql_server.postgresql_server.name
  charset             = "UTF8"
  collation           = "en_US.UTF8"
}

