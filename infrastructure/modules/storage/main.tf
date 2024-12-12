resource "azurerm_storage_account" "storage_account" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "storage_container" {
  name                  = "vhds"
  storage_account_id  = azurerm_storage_account.storage_account.id
  container_access_type = "private"
}


resource "azurerm_storage_blob" "blob_storage" {
  name                   = "amongus_picture.png"
  storage_account_name   = azurerm_storage_account.storage_account.name
  storage_container_name = azurerm_storage_container.storage_container.name
  type                   = "Block"
  source                 = "blob_image.png"
}
output "storage_account_name" {
  value = azurerm_storage_account.storage_account.name
}