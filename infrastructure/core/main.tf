data "azurerm_client_config" "current" {}

# Generate a random suffix for naming resources
resource "random_string" "resource_suffix" {
  length  = 6
  upper   = false
  special = false
}

# Random Passwords for Database
resource "random_password" "admin_password" {
  length  = 16
  special = true
}

resource "random_password" "database_password" {
  length  = 16
  special = true
}

# Create the Resource Group
resource "azurerm_resource_group" "base" {
  name     = "${var.base_rg_name}-${random_string.resource_suffix.result}"
  location = var.location
}

# TLS Provider: Generate Certificate (if still needed)
resource "tls_private_key" "root_cert_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_self_signed_cert" "root_cert" {
  private_key_pem = tls_private_key.root_cert_key.private_key_pem

  subject {
    common_name  = "RootCA"
    organization = "YourOrganization"
    country      = "US"
    province     = "California"
    locality     = "SanFrancisco"
  }

  validity_period_hours = 24 * 365
  is_ca_certificate     = true
  allowed_uses          = ["cert_signing", "key_encipherment", "digital_signature"]
}

# Invoke Modules

# VNet Module
module "vnet" {
  source                  = "../modules/vnet"
  location                = var.location
  unique_suffix           = random_string.resource_suffix.result
  resource_group_name     = azurerm_resource_group.base.name
  environment             = "dev"
  project_name            = "juniashop"
  address_space           = ["10.0.0.0/16"]
  db_subnet_prefix        = "10.0.1.0/24"
  app_subnet_prefix       = "10.0.2.0/24"
  gateway_subnet_prefix   = "10.0.3.0/24"
  vpn_client_address_pool = ["172.16.0.0/16"]
  tags = {
    Environment = "Development"
    Project     = "JuniaShop"
  }
}

# Private DNS Zone
resource "azurerm_private_dns_zone" "postgres_dns_zone" {
  name                = "privatelink.postgres.database.azure.com"
  resource_group_name = azurerm_resource_group.base.name
}

# Link Private DNS Zone to VNet
resource "azurerm_private_dns_zone_virtual_network_link" "postgres_dns_zone_link" {
  name                  = "link-${module.vnet.vnet_name}"
  resource_group_name   = azurerm_private_dns_zone.postgres_dns_zone.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.postgres_dns_zone.name
  virtual_network_id    = module.vnet.vnet_id

  registration_enabled = false

  depends_on = [
    module.vnet,
    azurerm_private_dns_zone.postgres_dns_zone
  ]
}

# Database Module
module "database" {
  source              = "../modules/database"
  location            = var.location
  resource_group_name = azurerm_resource_group.base.name
  unique_suffix       = random_string.resource_suffix.result
  project_name        = "juniashop"
  database_name       = "juniadb"
  admin_username      = "adminuser"
  subnet_id           = module.vnet.db_subnet_id
  private_dns_zone_id = azurerm_private_dns_zone.postgres_dns_zone.id
  environment         = "dev"

  admin_password    = random_password.admin_password.result
  database_password = random_password.database_password.result
}

# VPN Gateway Module
module "vpn_gateway" {
  source              = "../modules/vpn_gateway"
  location            = var.location
  resource_group_name = azurerm_resource_group.base.name
  project_name        = "juniashop"
  unique_suffix       = random_string.resource_suffix.result
  tags = {
    Environment = "Development"
    Project     = "JuniaShop"
  }
  gateway_subnet_id                            = module.vnet.gateway_subnet_id
  vpn_client_address_pool                      = ["172.16.0.0/16"]
  vpn_client_root_certificate_public_cert_data = base64encode(tls_self_signed_cert.root_cert.cert_pem)
  vnet_address_space                           = ["10.0.0.0/16"]
}

# Role Assignments for Owner SP
resource "azurerm_role_assignment" "owner_contributor" {
  principal_id         = var.owner_object_id
  role_definition_name = "Contributor"
  scope                = azurerm_resource_group.base.id
  principal_type       = "ServicePrincipal"
}

# Role Assignments for Developer SP
resource "azurerm_role_assignment" "developer_contributor" {
  principal_id         = var.developer_object_id
  role_definition_name = "Contributor"
  scope                = azurerm_resource_group.base.id
  principal_type       = "ServicePrincipal"
}
