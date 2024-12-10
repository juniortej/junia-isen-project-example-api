provider "azurerm" {
  features {}
  subscription_id = "9e01d033-be6a-400c-91a9-6376a10e4f16"
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

module "app_service" {
  source              = "./modules/app_service"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  prefix              = var.prefix
}

module "database" {
  source              = "./modules/database"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sql_server_name     = var.sql_server_name
  sql_database_name   = var.sql_database_name
  admin_username      = var.admin_username
  admin_password      = var.admin_password
}

module "storage" {
  source              = "./modules/storage"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  storage_account_name = var.storage_account_name
}

module "network" {
  source              = "./modules/network"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  prefix              = var.prefix
}