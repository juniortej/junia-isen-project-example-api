provider "azurerm" {
  features {}
  subscription_id = "9e01d033-be6a-400c-91a9-6376a10e4f16"
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# App Service Plan
module "app_service" {
  source = "./modules/app_service"
  prefix = var.prefix
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
}

# Azure SQL Database
module "database" {
  source = "./modules/database"
  sql_server_name = var.sql_server_name
  sql_database_name = var.sql_database_name
  admin_username = var.admin_username
  admin_password = var.admin_password
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
}

# Azure Blob Storage
module "storage" {
  source = "./modules/storage"
  storage_account_name = var.storage_account_name
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
}

output "app_service_url" {
  value = module.app_service.app_service_url
}

output "sql_server_fqdn" {
  value = module.database.sql_server_fqdn
}

output "storage_account_name" {
  value = module.storage.storage_account_name
}
