# infrastructure/core/main.tf

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

# VNet Module
module "vnet" {
  source                  = "../modules/vnet"
  location                = var.location
  unique_suffix           = random_string.resource_suffix.result
  resource_group_name     = azurerm_resource_group.base.name
  environment             = "dev"
  project_name            = var.project_name
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
  project_name        = var.project_name
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
  project_name        = var.project_name
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

# Generate a random JWT secret
resource "random_password" "jwt_secret" {
  length  = 32
  special = true
}

# Azure Container Registry
resource "azurerm_container_registry" "main" {
  name                = "${lower(var.project_name)}acr${random_string.resource_suffix.result}"
  location            = var.location
  resource_group_name = azurerm_resource_group.base.name
  sku                 = "Basic"
  admin_enabled       = true

  tags = {
    environment = "dev"
  }
}

# Container Registry Task to build and push the image
resource "azurerm_container_registry_task" "main" {
  name                  = "${var.project_name}-build-task-${random_string.resource_suffix.result}"
  container_registry_id = azurerm_container_registry.main.id

  platform {
    os           = "Linux"
    architecture = "amd64"
  }

  docker_step {
    dockerfile_path      = "shop-app/Dockerfile"
    context_path         = "${var.git_repo_url}#${var.git_branch}:shop-app"
    image_names          = ["${azurerm_container_registry.main.login_server}/shop-app:latest"]
    push_enabled         = true
    context_access_token = var.context_access_token
  }

  tags = {
    environment = "dev"
  }
}

# App Service Module
module "app_service" {
  source               = "../modules/app_service"
  resource_group_name  = azurerm_resource_group.base.name
  location             = var.location
  project_name         = var.project_name
  unique_suffix        = random_string.resource_suffix.result
  environment          = "dev"
  app_service_plan_sku = "B1"
  app_service_name     = "juniashop-app-${random_string.resource_suffix.result}"

  container_image_name = "${azurerm_container_registry.main.login_server}/shop-app"
  container_image_tag  = "latest"

  env_vars = {
    AZURE_POSTGRES_USER     = module.database.postgresql_administrator_login
    AZURE_POSTGRES_PASSWORD = module.database.postgresql_admin_password
    AZURE_POSTGRES_DB       = module.database.postgresql_database_name
    AZURE_POSTGRES_HOST     = module.database.postgresql_server_fqdn
    AZURE_POSTGRES_PORT     = "5432"
    DB_CONNECTION_TYPE      = "azure"
    JWT_SECRET              = random_password.jwt_secret.result
  }

  depends_on = [azurerm_container_registry_task.main]
}