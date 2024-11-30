# main.tf

# Generate a unique suffix for resource names
resource "random_string" "unique_suffix" {
  length  = 6
  upper   = false
  special = false
}

# Create a resource group
resource "azurerm_resource_group" "main" {
  name     = "${var.project_name}-rg-${random_string.unique_suffix.result}"
  location = var.location

  tags = {
    environment = var.environment
    project     = var.project_name
  }
}

# Virtual Network Module
module "vnet" {
  source              = "./modules/vnet"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  environment         = var.environment
  project_name        = var.project_name
  unique_suffix       = random_string.unique_suffix.result

  address_space         = var.vnet_address_space
  db_subnet_prefix      = "10.0.1.0/24"
  app_subnet_prefix     = "10.0.2.0/24"
  gateway_subnet_prefix = "10.0.3.0/24"

  vpn_client_address_pool = var.vpn_client_address_pool

  tags = {
    environment = var.environment
    project     = var.project_name
  }
}

# Create a Private DNS Zone for PostgreSQL
resource "azurerm_private_dns_zone" "postgres" {
  name                = "privatelink.postgres.database.azure.com"
  resource_group_name = azurerm_resource_group.main.name
}

# Link the VNet to the Private DNS Zone
resource "azurerm_private_dns_zone_virtual_network_link" "postgres_link" {
  name                  = "postgres-dns-zone-link"
  private_dns_zone_name = azurerm_private_dns_zone.postgres.name
  virtual_network_id    = module.vnet.vnet_id
  resource_group_name   = azurerm_resource_group.main.name
  registration_enabled  = false
}

# Database Module
module "database" {
  source              = "./modules/database"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  project_name        = var.project_name
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  subnet_id           = module.vnet.db_subnet_id
  private_dns_zone_id = azurerm_private_dns_zone.postgres.id
  environment         = var.environment
  unique_suffix       = random_string.unique_suffix.result
  database_name       = var.database_name
}

# VPN Gateway Module
module "vpn_gateway" {
  source              = "./modules/vpn_gateway"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  project_name        = var.project_name
  unique_suffix       = random_string.unique_suffix.result

  tags = {
    environment = var.environment
    project     = var.project_name
  }

  gateway_subnet_id                            = module.vnet.gateway_subnet_id
  vpn_client_address_pool                      = var.vpn_client_address_pool
  vpn_client_root_certificate_public_cert_data = var.vpn_client_root_certificate_public_cert_data
  vnet_address_space                           = var.vnet_address_space
}
