provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.11.0"
    }
  }
}

resource "azurerm_virtual_network" "shop_app_vnet" {
  name                = "shop-app-vnet"
  location            = azurerm_resource_group.shop_app_rg.location
  resource_group_name = azurerm_resource_group.shop_app_rg.name
  address_space       = [var.vnet_address_space]
}

resource "azurerm_subnet" "app_service_subnet" {
  name                 = "app-service-subnet"
  resource_group_name  = azurerm_resource_group.shop_app_rg.name
  virtual_network_name = azurerm_virtual_network.shop_app_vnet.name
  address_prefixes     = [var.subnet_app_service]
  delegation {
    name = "webapp_delegation"
    service_delegation {
      name = "Microsoft.Web/serverFarms"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/action"
      ]
    }
  }
}

resource "azurerm_subnet" "cosmosdb_subnet" {
  name                 = "cosmosdb-subnet"
  resource_group_name  = azurerm_resource_group.shop_app_rg.name
  virtual_network_name = azurerm_virtual_network.shop_app_vnet.name
  address_prefixes     = [var.subnet_cosmosdb]

  service_endpoints = ["Microsoft.AzureCosmosDB"]
}

resource "azurerm_subnet" "default_subnet" {
  name                 = "default-subnet"
  resource_group_name  = azurerm_resource_group.shop_app_rg.name
  virtual_network_name = azurerm_virtual_network.shop_app_vnet.name
  address_prefixes     = ["10.0.3.0/24"]
}


resource "azurerm_resource_group" "shop_app_rg" {
  name     = "shop-app-cc-junia"
  location = "France Central"
}

resource "azurerm_service_plan" "shop_app_plan" {
  name                = "shop-app-plan"
  location            = azurerm_resource_group.shop_app_rg.location
  resource_group_name = azurerm_resource_group.shop_app_rg.name
  os_type             = "Linux"
  sku_name            = "B1"
}


resource "azurerm_linux_web_app" "shop_app_service" {
  depends_on = [azurerm_service_plan.shop_app_plan]
  name                = var.app_service_name
  location            = azurerm_resource_group.shop_app_rg.location
  resource_group_name = azurerm_resource_group.shop_app_rg.name
  service_plan_id     = azurerm_service_plan.shop_app_plan.id

  https_only = true

  site_config {
    always_on = "true"  

    application_stack {
      docker_registry_url       = "https://index.docker.io/v1/"
      docker_registry_username = var.docker_registry_username
      docker_registry_password = var.docker_registry_password
      docker_image_name = "guayben/shop-app:latest"
    }  
  }

  virtual_network_subnet_id = azurerm_subnet.app_service_subnet.id 


  app_settings = {
    API_KEY = var.api_key
  }

  client_affinity_enabled = false
}


resource "azurerm_cosmosdb_account" "shop_app_cosmosdb" {
  name                = "shop-app-cosmosdb"
  location            = azurerm_resource_group.shop_app_rg.location
  resource_group_name = azurerm_resource_group.shop_app_rg.name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"
  is_virtual_network_filter_enabled = true
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
    id = azurerm_subnet.cosmosdb_subnet.id  # Ajout du sous-réseau CosmosDB
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

