#!/bin/bash

set -e

# Define directories
SCRIPT_DIR="$(dirname "$0")"
BASE_DIR="$SCRIPT_DIR/../base"

echo "🧹 Starting cleanup for the base infrastructure..."

# Step 1: Retrieve variables from Terraform outputs
echo "📦 Retrieving Terraform outputs..."
AZURE_TENANT_DOMAIN=$(terraform -chdir="$BASE_DIR" output -raw azure_tenant_domain)
GITHUB_ACTION_USER=$(terraform -chdir="$BASE_DIR" output -raw github_action_user_principal_name)
GITHUB_ACTION_ROLE_ID=$(terraform -chdir="$BASE_DIR" output -raw github_action_user_role_id)
RESOURCE_GROUP_NAME=$(terraform -chdir="$BASE_DIR" output -raw rg_name)
STORAGE_ACCOUNT_NAME=$(terraform -chdir="$BASE_DIR" output -raw storage_account_name)
KEY_VAULT_NAME=$(terraform -chdir="$BASE_DIR" output -raw key_vault_name)

echo "🧾 Retrieved the following values:"
echo "Azure Tenant Domain: $AZURE_TENANT_DOMAIN"
echo "GitHub Action User: $GITHUB_ACTION_USER"
echo "Role Assignment ID: $GITHUB_ACTION_ROLE_ID"
echo "Resource Group Name: $RESOURCE_GROUP_NAME"
echo "Storage Account Name: $STORAGE_ACCOUNT_NAME"
echo "Key Vault Name: $KEY_VAULT_NAME"

# Step 2: Delete Azure AD User
echo "🗑️ Deleting Azure AD User: $GITHUB_ACTION_USER..."
az ad user delete --id "$GITHUB_ACTION_USER" || echo "⚠️ User not found or already deleted."

# Step 3: Delete Role Assignment
echo "🗑️ Deleting Role Assignment: $GITHUB_ACTION_ROLE_ID..."
az role assignment delete --ids "$GITHUB_ACTION_ROLE_ID" || echo "⚠️ Role Assignment not found or already deleted."

# Step 4: Delete Key Vault
echo "🗑️ Deleting Key Vault: $KEY_VAULT_NAME..."
az keyvault delete --name "$KEY_VAULT_NAME" || echo "⚠️ Key Vault not found or already deleted."
az keyvault purge --name "$KEY_VAULT_NAME" || echo "⚠️ Key Vault already purged or not found."

# Step 5: Delete Resource Group
echo "🗑️ Deleting Resource Group: $RESOURCE_GROUP_NAME..."
az group delete --name "$RESOURCE_GROUP_NAME" --yes --no-wait || echo "⚠️ Resource Group not found or already deleted."

# Step 6: Delete Storage Account
echo "🗑️ Deleting Storage Account: $STORAGE_ACCOUNT_NAME..."
az storage account delete --name "$STORAGE_ACCOUNT_NAME" --resource-group "$RESOURCE_GROUP_NAME" --yes || echo "⚠️ Storage Account not found or already deleted."

# Step 7: Clean Terraform State
echo "🧹 Cleaning up Terraform state..."
terraform -chdir="$BASE_DIR" state rm "azuread_user.github_action_user" || echo "⚠️ Terraform state resource 'azuread_user.github_action_user' not found."
terraform -chdir="$BASE_DIR" state rm "azurerm_resource_group.tfstate" || echo "⚠️ Terraform state resource 'azurerm_resource_group.tfstate' not found."
terraform -chdir="$BASE_DIR" state rm "azurerm_storage_account.tfstate" || echo "⚠️ Terraform state resource 'azurerm_storage_account.tfstate' not found."
terraform -chdir="$BASE_DIR" state rm "azurerm_storage_container.tfstate" || echo "⚠️ Terraform state resource 'azurerm_storage_container.tfstate' not found."
terraform -chdir="$BASE_DIR" state rm "azurerm_key_vault.main" || echo "⚠️ Terraform state resource 'azurerm_key_vault.main' not found."

echo "🎉 Base infrastructure cleanup completed successfully!"
