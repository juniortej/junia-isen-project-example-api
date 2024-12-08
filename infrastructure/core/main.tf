##################################
# Random Unique Suffix Generator #
##################################

resource "random_string" "unique_suffix" {
  length  = 6
  upper   = false
  special = false
}


###########################
# Resource Group for Core #
###########################

resource "azurerm_resource_group" "main" {
  name     = "${var.project_name}-rg-${random_string.unique_suffix.result}"
  location = var.location

  tags = {
    environment = var.environment
    project     = var.project_name
  }
}


#############################
# Private DNS Zone for DB   #
#############################

resource "azurerm_private_dns_zone" "postgres" {
  name                = "privatelink.postgres.database.azure.com"
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "postgres_link" {
  name                  = "postgres-dns-zone-link"
  private_dns_zone_name = azurerm_private_dns_zone.postgres.name
  virtual_network_id    = module.vnet.vnet_id
  resource_group_name   = azurerm_resource_group.main.name
  registration_enabled  = false
}


######################
# Call VNet Module   #
######################

module "vnet" {
  source              = "../modules/vnet"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  environment         = var.environment
  project_name        = var.project_name
  unique_suffix       = random_string.unique_suffix.result

  address_space         = var.vnet_address_space
  db_subnet_prefix      = var.db_subnet_prefix
  app_subnet_prefix     = var.app_subnet_prefix
  gateway_subnet_prefix = var.gateway_subnet_prefix

  vpn_client_address_pool = var.vpn_client_address_pool

  tags = {
    environment = var.environment
    project     = var.project_name
  }
}


########################
# Call Key Vault Module#
########################

module "key_vault" {
  source              = "../modules/key_vault"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  project_name        = var.project_name
  unique_suffix       = random_string.unique_suffix.result

  admin_password                               = var.admin_password
  admin_username                               = var.admin_username
  database_name                                = var.database_name
  vpn_client_root_certificate_public_cert_data = var.vpn_client_root_certificate_public_cert_data

  tags = {
    environment = var.environment
    project     = var.project_name
  }

  object_id = var.key_vault_object_id
}


#########################
# Call Database Module  #
#########################

module "database" {
  source              = "../modules/database"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  project_name        = var.project_name
  admin_username      = var.admin_username
  database_name       = var.database_name
  subnet_id           = module.vnet.db_subnet_id
  private_dns_zone_id = azurerm_private_dns_zone.postgres.id
  environment         = var.environment
  unique_suffix       = random_string.unique_suffix.result
  key_vault_id        = module.key_vault.key_vault_id
}


###########################
# Call VPN Gateway Module #
###########################

module "vpn_gateway" {
  source              = "../modules/vpn_gateway"
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
