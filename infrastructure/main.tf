provider "azurerm" {
  features {}
  subscription_id = "8695039e-5771-4111-ace7-db81228d3f22"
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
  storage_container_name = var.storage_container_name
  storage_blob_name  = var.storage_blob_name
  storage_blob_source  = var.storage_blob_source
  
}

module "network" {
  source              = "./modules/network"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  prefix              = var.prefix
}