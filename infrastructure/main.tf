resource "random_string" "unique_suffix" {
  length  = 6
  upper   = false
  special = false
}

resource "azurerm_resource_group" "main" {
  name     = "${var.project_name}-rg-${random_string.unique_suffix.result}"
  location = var.location
}

module "vnet" {
  source              = "./modules/vnet"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  environment         = var.environment
  project_name        = var.project_name
}

resource "azurerm_private_dns_zone" "main" {
  name                = "postgres.database.azure.com"
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "main" {
  name                  = "dns-zone-link"
  private_dns_zone_name = azurerm_private_dns_zone.main.name
  virtual_network_id    = module.vnet.vnet_id
  resource_group_name   = azurerm_resource_group.main.name
}

module "database" {
  source              = "./modules/database"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  project_name        = var.project_name
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  subnet_id           = module.vnet.db_subnet_id
  private_dns_zone_id = azurerm_private_dns_zone.main.id
  environment         = var.environment
}
