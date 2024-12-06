resource "azurerm_mssql_server" "sql_server" {
  name                         = var.sql_server_name
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = var.admin_username
  administrator_login_password = var.admin_password
  minimum_tls_version          = "1.2"
}

resource "azurerm_mssql_database" "sql_database" {
  name                = var.sql_database_name
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mssql_server.sql_server.name
  sku_name            = var.sql_sku_name
  collation           = "SQL_Latin1_General_CP1_CI_AS"
}
