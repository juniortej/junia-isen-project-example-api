data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "main" {
  name                        = "${var.project_name}-kv-${var.unique_suffix}"
  location                    = var.location
  resource_group_name         = var.resource_group_name
  sku_name                    = "standard"
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 90
  purge_protection_enabled    = true

  tags = var.tags
}

resource "azurerm_role_assignment" "key_vault_secrets_user" {
  principal_id         = var.object_id
  role_definition_name = "Key Vault Secrets User"
  scope                = azurerm_key_vault.main.id
}

resource "azurerm_key_vault_secret" "admin_password" {
  name         = "admin-password"
  value        = var.admin_password
  key_vault_id = azurerm_key_vault.main.id
}

resource "azurerm_key_vault_secret" "admin_username" {
  name         = "admin-username"
  value        = var.admin_username
  key_vault_id = azurerm_key_vault.main.id
}

resource "azurerm_key_vault_secret" "database_name" {
  name         = "database-name"
  value        = var.database_name
  key_vault_id = azurerm_key_vault.main.id
}

resource "azurerm_key_vault_secret" "vpn_client_root_certificate_public_cert_data" {
  name         = "vpn-client-root-cert-data"
  value        = var.vpn_client_root_certificate_public_cert_data
  key_vault_id = azurerm_key_vault.main.id
}
