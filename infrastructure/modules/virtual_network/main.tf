provider "azurerm" {
  features {}
}

# Création du groupe de ressources si nécessaire
resource "azurerm_resource_group" "vnet_rg" {
  name     = var.resource_group_name
  location = var.location
}

# Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  location            = azurerm_resource_group.vnet_rg.location
  resource_group_name = azurerm_resource_group.vnet_rg.name
  address_space       = var.vnet_address_space
}

# Subnet pour CosmosDB
resource "azurerm_subnet" "cosmosdb_subnet" {
  name                 = var.cosmosdb_subnet_name
  resource_group_name  = azurerm_resource_group.vnet_rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.cosmosdb_subnet_prefix]

  # Activer le service endpoint pour CosmosDB
  service_endpoints = ["Microsoft.AzureCosmosDB"]
}

# Subnet pour App Service
resource "azurerm_subnet" "appservice_subnet" {
  name                 = var.appservice_subnet_name
  resource_group_name  = azurerm_resource_group.vnet_rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.appservice_subnet_prefix]

  # Activer le service endpoint pour App Service (si nécessaire)
  service_endpoints = ["Microsoft.Web"]
}
