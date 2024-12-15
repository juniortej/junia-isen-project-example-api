output "resource_group_name" {
  description = "Nom du groupe de ressources"
  value       = module.resource_group.name
}

output "vnet_id" {
  description = "ID du réseau virtuel"
  value       = module.virtual_network.vnet_id
}

output "app_service_url" {
  description = "URL de l'application web (App Service)"
  value       = module.app_service.default_hostname
}

output "cosmosdb_endpoint" {
  description = "Endpoint du compte CosmosDB"
  value       = module.cosmosdb.endpoint
}

output "blob_storage_account_name" {
  description = "Nom du compte de stockage"
  value       = module.blob_storage.storage_account_name
}
