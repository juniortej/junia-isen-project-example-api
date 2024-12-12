output "storage_account_name" {
    description = "Storage account name: "
    value       = azurerm_storage_account.storage_account.name
}

output "storage_blob_name" {
    description = "Storage blob name: "
    value       = azurerm_storage_blob.storage_blob.name
}

output "storage_account_id" {
    description = "Storage account id: "
    value       = azurerm_storage_account.storage_account.id
}

output "storage_url" {
    description = "Storage URL: "
    value       = azurerm_storage_account.storage_account.primary_blob_endpoint
}