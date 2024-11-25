provider "azurerm" {
  features {}
  subscription_id = "79f11903-d0db-47a2-acc8-ce9d9d3fa470"
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.11.0"
    }
  }
}


resource "azurerm_resource_group" "shop_app_rg" {
  name     = "shop-app-cc-junia"
  location = "France Central"
}

resource "azurerm_service_plan" "shop_app_plan" {
  name                = "shop-app-plan"
  location            = azurerm_resource_group.shop_app_rg.location
  resource_group_name = azurerm_resource_group.shop_app_rg.name
  os_type             = "Windows"
  sku_name            = "B1"
}


resource "azurerm_windows_web_app" "shop_app_service" {
  depends_on = [azurerm_service_plan.shop_app_plan]
  name                = var.app_service_name
  location            = azurerm_resource_group.shop_app_rg.location
  resource_group_name = azurerm_resource_group.shop_app_rg.name
  service_plan_id = azurerm_service_plan.shop_app_plan.id
  timeouts {
    create = "1m"
  }
  site_config{}
}


resource "azurerm_cosmosdb_account" "shop_app_cosmosdb" {
  name                = "shop-app-cosmosdb"
  location            = azurerm_resource_group.shop_app_rg.location
  resource_group_name = azurerm_resource_group.shop_app_rg.name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"
  consistency_policy {
    consistency_level       = "Session"
    max_interval_in_seconds = 5
    max_staleness_prefix    = 100
  }
  geo_location {
    location          = azurerm_resource_group.shop_app_rg.location
    failover_priority = 0
  }
}

resource "azurerm_cosmosdb_sql_database" "shop_app_db" {
  name                = "shop-app-db"
  resource_group_name = azurerm_resource_group.shop_app_rg.name
  account_name        = azurerm_cosmosdb_account.shop_app_cosmosdb.name
}

resource "azurerm_cosmosdb_sql_container" "shop_app_container" {
  name                = "shop-app-container"
  resource_group_name = azurerm_resource_group.shop_app_rg.name
  account_name        = azurerm_cosmosdb_account.shop_app_cosmosdb.name
  database_name       = azurerm_cosmosdb_sql_database.shop_app_db.name
  partition_key_paths  = ["/partitionKey"]
  throughput          = 400
}


