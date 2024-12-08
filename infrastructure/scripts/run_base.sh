#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_DIR="$SCRIPT_DIR/../base"

echo "🌐 Retrieving the User Principal Name (UPN) of the signed-in user..."
UPN=$(az ad signed-in-user show --query "userPrincipalName" -o tsv)

# 🏢 Extract the tenant domain from UPN (user@tenant.com)
TENANT_DOMAIN=$(echo "$UPN" | awk -F'@' '{print $2}')
export TF_VAR_azure_tenant_domain="$TENANT_DOMAIN"

echo "🚀 Your Azure User Principal Name (UPN) is: $UPN"
echo "🏢 Your Azure Tenant Domain is: $TENANT_DOMAIN"

echo "📂 Running 'terraform fmt' to format the configuration files in base directory..."
terraform fmt -recursive "$BASE_DIR"

echo "📦 Running 'terraform init' to initialize the backend and provider plugins in base directory..."
terraform -chdir="$BASE_DIR" init

echo "✅ Running 'terraform validate' to ensure the configuration files are valid..."
terraform -chdir="$BASE_DIR" validate

echo "📋 Running 'terraform plan' to preview the changes in base directory..."
terraform -chdir="$BASE_DIR" plan -out=tfplan

echo "⚡ Applying the Terraform configuration for base infrastructure... (Only type 'yes' to approve)"
terraform -chdir="$BASE_DIR" apply tfplan

echo "📡 Retrieving and exporting outputs from Terraform..."
STORAGE_ACCOUNT_NAME=$(terraform -chdir="$BASE_DIR" output -raw storage_account_name)
CONTAINER_NAME=$(terraform -chdir="$BASE_DIR" output -raw container_name)
KEY_VAULT_NAME=$(terraform -chdir="$BASE_DIR" output -raw key_vault_name)

export AZURE_TENANT_DOMAIN="$TENANT_DOMAIN"
export STORAGE_ACCOUNT_NAME="$STORAGE_ACCOUNT_NAME"
export CONTAINER_NAME="$CONTAINER_NAME"
export KEY_VAULT_NAME="$KEY_VAULT_NAME"

echo "🧪 Exported environment variables:"
echo "AZURE_TENANT_DOMAIN=$AZURE_TENANT_DOMAIN"
echo "STORAGE_ACCOUNT_NAME=$STORAGE_ACCOUNT_NAME"
echo "CONTAINER_NAME=$CONTAINER_NAME"
echo "KEY_VAULT_NAME=$KEY_VAULT_NAME"

# Optional: Save outputs to a .env file for later use
echo "🌐 Saving environment variables to .env file in base directory..."
cat <<EOF > "$BASE_DIR/.env"
AZURE_TENANT_DOMAIN=$AZURE_TENANT_DOMAIN
STORAGE_ACCOUNT_NAME=$STORAGE_ACCOUNT_NAME
CONTAINER_NAME=$CONTAINER_NAME
KEY_VAULT_NAME=$KEY_VAULT_NAME
EOF

echo "🎉 Base infrastructure deployed successfully!"
echo "✅ You can now use the outputs for next steps (e.g., configuring backend in core folder)."
