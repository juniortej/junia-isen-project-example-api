output "rg_name" {
  description = "Resource Group Name"
  value       = azurerm_resource_group.tfstate.name
}

output "storage_account_name" {
  description = "The name of the storage account"
  value       = azurerm_storage_account.tfstate.name
}

output "container_name" {
  description = "The name of the storage container"
  value       = azurerm_storage_container.tfstate.name
}

output "github_action_user_principal_name" {
  description = "The principal name (email) of the GitHub Action user"
  value       = azuread_user.github_action_user.user_principal_name
}

output "github_action_user_password" {
  description = "The initial password for the GitHub Action user"
  value       = random_password.github_action_user_password.result
  sensitive   = true
}

output "github_action_user_role_id" {
  description = "The ID of the role assignment for the GitHub Action user"
  value       = azurerm_role_assignment.github_action_user_role.id
}

output "key_vault_id" {
  description = "The ID of the Key Vault"
  value       = azurerm_key_vault.main.id
}

output "key_vault_name" {
  description = "The name of the Key Vault"
  value       = azurerm_key_vault.main.name
}
