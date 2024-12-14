#!/bin/bash

# infrastructure/scripts/run_core.sh

# ================================
# 🚀 **Set Fail-Safe Options**
# ================================
set -e
set -o pipefail

# Trap and log errors
trap 'echo "❌ An error occurred at line $LINENO while running $BASH_COMMAND. Check the logs above for details."' ERR

# ================================
# 📂 **Set Directory Paths**
# ================================
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CORE_DIR="$SCRIPT_DIR/../core"
PLAN_FILE="/tmp/tfplan"

# ================================
# 📁 **Source Environment Variables**
# ================================
ENV_FILE="$SCRIPT_DIR/../.env"

if [[ -f "$ENV_FILE" ]]; then
  echo "🔗 Sourcing environment variables from $ENV_FILE"
  set -a
  source "$ENV_FILE"  
  set +a
else
  echo "❌ .env file not found at $ENV_FILE. Please ensure it exists and contains the necessary variables."
  exit 1
fi

# ================================
# 🛠️ **Utility Functions**
# ================================

# 📋 Check if required tools are installed
check_required_tools() {
  echo "📋 Checking required tools..."
  for tool in terraform az jq curl; do
    if ! command -v $tool &> /dev/null; then
      echo "❌ Required tool '$tool' is not installed. Please install it before running this script."
      exit 1
    fi
  done
}

# 🔐 Check Azure authentication and subscription
check_azure_authentication() {
  echo "🔐 Checking Azure authentication..."
  AZURE_SUBSCRIPTION_ID_CURRENT=$(az account show --query "id" -o tsv)
  if [[ -z "$AZURE_SUBSCRIPTION_ID_CURRENT" ]]; then
    echo "❌ You are not authenticated to Azure. Please run 'az login' to authenticate."
    exit 1
  fi
  echo "✅ Authenticated to Azure Subscription: $AZURE_SUBSCRIPTION_ID_CURRENT"
}

# 🧪 Retrieve Terraform outputs safely
get_terraform_output() {
  local key="$1"
  local value
  value=$(terraform -chdir="$CORE_DIR" output -raw "$key" 2>/dev/null || echo "")
  if [[ -z "$value" ]]; then
    echo "❌ Missing Terraform output for: $key"
    exit 1
  fi
  echo "$value"
}

# ================================
# 🚀 **Run Deployment Process**
# ================================

check_required_tools

check_azure_authentication

# Ensure required environment variables are set
REQUIRED_VARS=("DEVELOPER_SP_OBJECT_ID" "OWNER_SP_OBJECT_ID")
for var in "${REQUIRED_VARS[@]}"; do
  if [[ -z "${!var}" ]]; then
    echo "❌ Environment variable '$var' is not set in $ENV_FILE."
    exit 1
  fi
done
echo "✅ All required environment variables are set."

echo "📂 Running 'terraform fmt' to format the configuration files in the core directory..."
terraform fmt -recursive "$CORE_DIR"

echo "📦 Running 'terraform init' to initialize the backend and provider plugins in the core directory..."
terraform -chdir="$CORE_DIR" init

echo "✅ Running 'terraform validate' to ensure the configuration files are valid..."
terraform -chdir="$CORE_DIR" validate

echo "📋 Running 'terraform plan' to preview the changes in the core directory..."
terraform -chdir="$CORE_DIR" plan \
  -var "developer_object_id=$DEVELOPER_SP_OBJECT_ID" \
  -var "owner_object_id=$OWNER_SP_OBJECT_ID" \
  -var "context_access_token=$GITHUB_TOKEN" \
  -out="$PLAN_FILE"

echo "⚡ Applying the Terraform configuration for core infrastructure... (Only type 'yes' to approve)"
terraform -chdir="$CORE_DIR" apply "$PLAN_FILE"

echo "📡 Retrieving and exporting outputs from Terraform..."
RESOURCE_GROUP_NAME=$(get_terraform_output "resource_group_name")
POSTGRESQL_SERVER_NAME=$(get_terraform_output "postgresql_server_name")
POSTGRESQL_SERVER_FQDN=$(get_terraform_output "postgresql_server_fqdn")
POSTGRESQL_DATABASE_NAME=$(get_terraform_output "postgresql_database_name")
POSTGRESQL_ADMIN_PASSWORD=$(terraform -chdir="$CORE_DIR" output -raw postgresql_admin_password)
DATABASE_PASSWORD=$(terraform -chdir="$CORE_DIR" output -raw database_password)
VPN_PUBLIC_IP=$(get_terraform_output "vpn_gateway_public_ip")

# Export Variables (if needed for further scripts or usage)
export RESOURCE_GROUP_NAME
export POSTGRESQL_SERVER_NAME
export POSTGRESQL_SERVER_FQDN
export POSTGRESQL_DATABASE_NAME
export POSTGRESQL_ADMIN_PASSWORD
export DATABASE_PASSWORD
export VPN_PUBLIC_IP

echo "✅ Deployment Complete!"
echo "🔑 Resource Group: $RESOURCE_GROUP_NAME"
echo "🔐 PostgreSQL Server: $POSTGRESQL_SERVER_NAME"
echo "🔐 PostgreSQL FQDN: $POSTGRESQL_SERVER_FQDN"
echo "🔐 PostgreSQL Database: $POSTGRESQL_DATABASE_NAME"
echo "🔐 PostgreSQL Admin Password: $POSTGRESQL_ADMIN_PASSWORD"
echo "🔐 Database Password: $DATABASE_PASSWORD"
echo "🌐 VPN Gateway Public IP: $VPN_PUBLIC_IP"
