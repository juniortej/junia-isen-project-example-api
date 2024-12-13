# ID du Virtual Network
output "vnet_id" {
  value       = azurerm_virtual_network.vnet.id
  description = "L'ID du Virtual Network créé"
}

# ID du sous-réseau CosmosDB
output "cosmosdb_subnet_id" {
  value       = azurerm_subnet.cosmosdb_subnet.id
  description = "L'ID du sous-réseau pour CosmosDB"
}

# ID du sous-réseau App Service
output "appservice_subnet_id" {
  value       = azurerm_subnet.appservice_subnet.id
  description = "L'ID du sous-réseau pour App Service"
}
