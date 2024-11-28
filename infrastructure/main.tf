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
}