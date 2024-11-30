# Resource Group Outputs

output "resource_group_name" {
  value       = module.resource_group.resource_group_name
}

output "resource_group_location" {
  value       = module.resource_group.resource_group_location
}

output "resource_group_id" {
  value       = module.resource_group.resource_group_id
}

# Virtual Network Outputs

output "virtual_network_name" {
  value       = module.virtual_network.virtual_network_name
}

output "virtual_network_address_space" {
  value       = module.virtual_network.virtual_network_address_space
}

output "virtual_network_id" {
  value       = module.virtual_network.virtual_network_id
}

output "database_subnet_name" {
  value       = module.virtual_network.database_subnet_name
}

output "database_subnet_address_space" {
  value       = module.virtual_network.database_subnet_address_space
}

output "database_subnet_id" {
  value       = module.virtual_network.database_subnet_id
}

# Database Outputs

output "db_host" {
  value       = module.database.db_host
}

output "db_port" {
  value       = module.database.db_port
}

output "db_name" {
  value       = module.database.db_name
}

output "db_admin_username" {
  value       = module.database.db_admin_username
  sensitive   = true
}

output "db_admin_password" {
  value       = module.database.db_admin_password
  sensitive   = true
}

# Blob Storage Outputs
output "storage_account_name" {
  value       = module.blob_storage.storage_account_name
}

output "storage_blob_name" {
  value       = module.blob_storage.storage_blob_name
}

output "storage_account_id" {
  value       = module.blob_storage.storage_account_id
}

output "storage_url" {
  value       = module.blob_storage.storage_url
}

# App Service Outputs
/*
output "app_service_name" {
  value       = azurerm_app_service.app_service.name
}

output "app_service_default_hostname" {
  value       = azurerm_app_service.app_service.default_site_hostname
}
*/