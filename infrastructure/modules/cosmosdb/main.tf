# Fournisseur Terraform pour Azure
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  required_version = ">= 1.0.0"
}

provider "azurerm" {
  features {}
}

# Groupe de ressources pour CosmosDB
resource "azurerm_resource_group" "shop_app_rg" {
  name     = var.resource_group_name
  location = var.location
}

# Compte CosmosDB
resource "azurerm_cosmosdb_account" "shop_app_cosmosdb" {
  name                             = var.cosmosdb_account_name
  location                         = azurerm_resource_group.shop_app_rg.location
  resource_group_name              = azurerm_resource_group.shop_app_rg.name
  offer_type                       = "Standard"
  kind                             = "GlobalDocumentDB"
  is_virtual_network_filter_enabled = true

  # Autoriser uniquement les connexions provenant de cette plage IP
  ip_range_filter = ["0.0.0.0"]

  consistency_policy {
    consistency_level       = "Session"
    max_interval_in_seconds = 5
    max_staleness_prefix    = 100
  }

  geo_location {
    location          = azurerm_resource_group.shop_app_rg.location
    failover_priority = 0
  }

  virtual_network_rule {
    id = var.cosmosdb_subnet_id
  }
}

# Base de données CosmosDB
resource "azurerm_cosmosdb_sql_database" "shop_app_db" {
  name                = var.database_name
  resource_group_name = azurerm_resource_group.shop_app_rg.name
  account_name        = azurerm_cosmosdb_account.shop_app_cosmosdb.name
}

# Conteneur Items
resource "azurerm_cosmosdb_sql_container" "items_container" {
  name                = "Items"
  resource_group_name = azurerm_resource_group.shop_app_rg.name
  account_name        = azurerm_cosmosdb_account.shop_app_cosmosdb.name
  database_name       = azurerm_cosmosdb_sql_database.shop_app_db.name
  partition_key_paths = ["/ItemsId"]
  throughput          = 400
}

# Conteneur Users
resource "azurerm_cosmosdb_sql_container" "users_container" {
  name                = "Users"
  resource_group_name = azurerm_resource_group.shop_app_rg.name
  account_name        = azurerm_cosmosdb_account.shop_app_cosmosdb.name
  database_name       = azurerm_cosmosdb_sql_database.shop_app_db.name
  partition_key_paths = ["/userId"]
  throughput          = 400
}

# Conteneur Baskets
resource "azurerm_cosmosdb_sql_container" "baskets_container" {
  name                = "Baskets"
  resource_group_name = azurerm_resource_group.shop_app_rg.name
  account_name        = azurerm_cosmosdb_account.shop_app_cosmosdb.name
  database_name       = azurerm_cosmosdb_sql_database.shop_app_db.name
  partition_key_paths = ["/basketId"]
  throughput          = 400
}

# Accès aux informations du compte CosmosDB
data "azurerm_cosmosdb_account" "shop_app_keys" {
  name                = azurerm_cosmosdb_account.shop_app_cosmosdb.name
  resource_group_name = azurerm_resource_group.shop_app_rg.name
}
