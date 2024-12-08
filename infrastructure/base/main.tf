##############################
# Data Sources and Providers #
##############################

data "azurerm_client_config" "current" {}

data "azurerm_subscription" "current" {}


##############################
# Random Resources (Suffixes)#
##############################

resource "random_string" "github_action_user_suffix" {
  length  = 6
  upper   = false
  special = false
}

resource "random_password" "github_action_user_password" {
  length  = 16
  special = true
}


#########################
# Resource Group (RG)   #
#########################

resource "azurerm_resource_group" "tfstate" {
  name     = var.tfstate_rg_name
  location = var.location
}


###############################
# Storage Account for Backend #
###############################

resource "azurerm_storage_account" "tfstate" {
  name                            = "${var.tfstate_sa_name}${random_string.github_action_user_suffix.result}"
  resource_group_name             = azurerm_resource_group.tfstate.name
  location                        = azurerm_resource_group.tfstate.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  allow_nested_items_to_be_public = true
}


##############################
# Storage Container for State#
##############################

resource "azurerm_storage_container" "tfstate" {
  name                  = var.tfstate_container_name
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "private"
}


######################################
# Azure AD User (GitHub Action User) #
######################################

resource "azuread_user" "github_action_user" {
  user_principal_name   = "${var.github_action_user_name_prefix}${random_string.github_action_user_suffix.result}@${var.azure_tenant_domain}"
  display_name          = "GitHub Action User"
  password              = random_password.github_action_user_password.result
  force_password_change = false
  account_enabled       = true
}


#####################################################
# Role Assignment: Contributor at Subscription Level #
#####################################################

resource "azurerm_role_assignment" "github_action_user_role" {
  principal_id         = azuread_user.github_action_user.object_id
  role_definition_name = "Contributor"
  scope                = data.azurerm_subscription.current.id
}


#########################
# Key Vault for Secrets #
#########################

# Unique name for the Key Vault
resource "azurerm_key_vault" "main" {
  name                        = "kv${random_string.github_action_user_suffix.result}"
  location                    = azurerm_resource_group.tfstate.location
  resource_group_name         = azurerm_resource_group.tfstate.name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "standard"
  soft_delete_retention_days  = 90
  purge_protection_enabled    = true
}


########################################################
# Key Vault Access Policy for the GitHub Action User   #
########################################################

resource "azurerm_key_vault_access_policy" "github_action_user_access" {
  key_vault_id = azurerm_key_vault.main.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azuread_user.github_action_user.object_id

  # Permissions to manage secrets (to store certificates, passwords, etc.)
  secret_permissions = ["get", "list", "set", "delete"]
}
