output "storage_account_name" {
  value = azurerm_storage_account.storage_account.name
  description = "The name of the Azure Storage Account."
}

output "container_name" {
  value = azurerm_storage_container.storage_container.name
  description = "The name of the Azure Storage Container."
}

output "storage_url" {
  description = "The URL of the blob storage"
  value       = azurerm_storage_account.storage_account.primary_blob_endpoint
}

output "storage_account_id" {
  description = "The ID of the storage account"
  value       = azurerm_storage_account.storage_account.id

}