#!/bin/bash

set -e 
trap 'echo "❌ Error occurred. Check the logs above for details."' ERR

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_DIR="$SCRIPT_DIR/../base"
CORE_DIR="$SCRIPT_DIR/../core"
PLAN_FILE="/tmp/tfplan" 

# 🛠️ Utility Function to retrieve and validate Terraform outputs
get_terraform_output() {
  local key="$1"
  local value=$(terraform -chdir="$BASE_DIR" output -raw "$key" 2>/dev/null || echo "")
  if [[ -z "$value" ]]; then
    echo "❌ Missing Terraform output for: $key"
    exit 1
  fi
  echo "$value"
}

# 🛠️ Check if required tools are installed
echo "📋 Checking required tools..."
for tool in terraform az awk; do
  if ! command -v $tool &> /dev/null; then
    echo "❌ Required tool '$tool' is not installed. Please install it before running this script."
    exit 1
  fi
done

echo "📡 Retrieving the User Principal Name (UPN) of the signed-in user..."
UPN=$(az ad signed-in-user show --query "userPrincipalName" -o tsv)

if [[ -z "$UPN" ]]; then
  echo "❌ Failed to retrieve the User Principal Name (UPN). Please ensure you are signed in to Azure."
  exit 1
fi

TENANT_DOMAIN=$(echo "$UPN" | awk -F'@' '{print $2}')
export TF_VAR_azure_tenant_domain="$TENANT_DOMAIN"

echo "🚀 Your Azure User Principal Name (UPN) is: $UPN"
echo "🏢 Your Azure Tenant Domain is: $TENANT_DOMAIN"

echo "📂 Running 'terraform fmt' to format the configuration files in the base directory..."
terraform fmt -recursive "$BASE_DIR"

echo "📦 Running 'terraform init' to initialize the backend and provider plugins in the base directory..."
terraform -chdir="$BASE_DIR" init

echo "✅ Running 'terraform validate' to ensure the configuration files are valid..."
terraform -chdir="$BASE_DIR" validate

echo "📋 Running 'terraform plan' to preview the changes in the base directory..."
terraform -chdir="$BASE_DIR" plan -out="$PLAN_FILE"

echo "⚡ Applying the Terraform configuration for base infrastructure... (Only type 'yes' to approve)"
terraform -chdir="$BASE_DIR" apply "$PLAN_FILE"

echo "📡 Retrieving and exporting outputs from Terraform..."
RESOURCE_GROUP_NAME=$(get_terraform_output "resource_group_name")
STORAGE_ACCOUNT_NAME=$(get_terraform_output "storage_account_name")
CONTAINER_NAME=$(get_terraform_output "container_name")

# Export key environment variables
export RESOURCE_GROUP_NAME="$RESOURCE_GROUP_NAME"
export STORAGE_ACCOUNT_NAME="$STORAGE_ACCOUNT_NAME"
export CONTAINER_NAME="$CONTAINER_NAME"

echo "🧪 Exported environment variables (sensitive data hidden):"
echo "RESOURCE_GROUP_NAME=$RESOURCE_GROUP_NAME"
echo "STORAGE_ACCOUNT_NAME=$STORAGE_ACCOUNT_NAME"
echo "CONTAINER_NAME=$CONTAINER_NAME"

echo "🌐 Saving backend configuration to core/backend.hcl"
cat <<EOF > "$CORE_DIR/backend.hcl"
resource_group_name  = "$RESOURCE_GROUP_NAME"
storage_account_name = "$STORAGE_ACCOUNT_NAME"
container_name       = "$CONTAINER_NAME"
key                  = "core.tfstate"
EOF

if [[ -f "$CORE_DIR/backend.hcl" ]]; then
  echo "✅ Backend configuration file created successfully at $CORE_DIR/backend.hcl"
else
  echo "❌ Failed to create the backend.hcl file. Please check your file permissions."
  exit 1
fi

echo "🎉 Base infrastructure deployed successfully!"
echo "✅ You can now use the outputs for the next steps."
