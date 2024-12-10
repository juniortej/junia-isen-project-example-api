output "app_service_name" {
  value = module.app_service.app_service_name
}

output "app_service_url" {
  value = module.app_service.app_service_url
}

output "database_name" {
  value = module.database.database_name
}

output "storage_account_name" {
  value = module.storage.storage_account_name
}

output "vnet_name" {
  value = module.network.vnet_name
}