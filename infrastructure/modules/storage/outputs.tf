output "storage_account_name" {
  description = "The name of the Storage Account"
  value       = azurerm_storage_account.storage.name
}

output "storage_container_url" {
  description = "The URL of the Storage Container"
  value       = azurerm_storage_container.app_data.id
}
