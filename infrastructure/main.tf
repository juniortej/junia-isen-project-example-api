provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

module "resource_group" {
  source                    = "./modules/resource_group"
  resource_group_name       = var.resource_group_name
  resource_group_location   = var.resource_group_location
}

module "virtual_network" {
  source                        = "./modules/virtual_network"
  resource_group_name           = module.resource_group.resource_group_name
  resource_group_location       = module.resource_group.resource_group_location
  virtual_network_name          = var.virtual_network_name
  virtual_network_address_space = var.virtual_network_address_space

  database_subnet_name          = var.database_subnet_name
  database_subnet_address_space = var.database_subnet_address_space
}

module "database" {
  source                    = "./modules/database"
  resource_group_name       = module.resource_group.resource_group_name
  resource_group_location   = module.resource_group.resource_group_location
  vnet_id                   = module.virtual_network.virtual_network_id
  database_subnet_id        = module.virtual_network.database_subnet_id
  dns_zone_name             = var.dns_zone_name
  dns_zone_link_name        = var.dns_zone_link_name
  database_admin_username   = var.database_admin_username
  database_admin_password   = var.database_admin_password
  database_name             = var.database_name
  server_name               = var.server_name
}