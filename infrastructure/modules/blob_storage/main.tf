resource "azurerm_storage_account" "storage_account" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.resource_group_location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  network_rules {
    default_action             = "Deny"
    ip_rules                   = [var.ip_authorized]
    virtual_network_subnet_ids = [var.storage_subnet_id]
  }
}

resource "azurerm_storage_container" "storage_container" {
  name                  = "api"
  storage_account_id  = azurerm_storage_account.storage_account.id
  container_access_type = "private"
}

resource "azurerm_role_assignment" "service_binding" {
  scope                = azurerm_storage_container.storage_container.resource_manager_id
  role_definition_name = "Storage Blob Data Reader"
  principal_id         = var.app_service_principal_id

  depends_on = [ azurerm_storage_container.storage_container ]
}

# On récupère le fichier items.json et on le stocke dans le blob storage
resource "azurerm_storage_blob" "storage_blob" {
  name                   = "items.json"
  storage_account_name   = azurerm_storage_account.storage_account.name
  storage_container_name = azurerm_storage_container.storage_container.name
  type                   = "Block"
  source                 = "${path.module}/../../../resources/blob_storage/items.json"
}