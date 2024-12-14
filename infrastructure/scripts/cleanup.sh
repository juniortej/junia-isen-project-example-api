#!/bin/bash

# ================================
# 🚀 **Set Fail-Safe Options**
# ================================
set -e
set -o pipefail

# Trap and log errors
trap 'echo "❌ An error occurred at line $LINENO while running $BASH_COMMAND. Check the logs above for details."' ERR

# ================================
# 🎉 CONFIGURABLE VARIABLES
# ================================
ENV_FILE="./../.env"

# ================================
# 🛠️ **Utility Functions**
# ================================

# 📋 Check if required tools are installed
check_required_tools() {
  echo "📋 Checking required tools..."
  for tool in terraform az; do
    if ! command -v "$tool" &> /dev/null; then
      echo "❌ Required tool '$tool' is not installed. Please install it before running this script."
      exit 1
    fi
  done
  echo "✅ All required tools are installed."
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
# 🔍 **Retrieve Service Principal Information**
# ================================
echo "📡 Retrieving Service Principal information from .env..."

if [[ -f "$ENV_FILE" ]]; then
  source "$ENV_FILE"
else
  echo "❌ .env file not found at $ENV_FILE. Exiting."
  exit 1
fi

OWNER_SP_APP_ID="${OWNER_SP_APP_ID}"
DEVELOPER_SP_APP_ID="${DEVELOPER_SP_APP_ID}"

# Check if SP App IDs are present
if [[ -z "$OWNER_SP_APP_ID" && -z "$DEVELOPER_SP_APP_ID" ]]; then
  echo "⚠️ No Service Principals found to delete."
else
  echo "✅ Service Principal App IDs retrieved successfully."
fi

# ================================
# 🛠️ **Main Cleanup Process**
# ================================

# 1. Check for required tools and Azure authentication
check_required_tools
check_azure_authentication

# 2. Destroy Terraform-managed resources
if [[ -d "$(dirname "$ENV_FILE")/../core" ]]; then
  echo "🛠️ Destroying Terraform-managed resources..."
  CORE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../core"
  
  if [[ -d "$CORE_DIR" ]]; then
    terraform -chdir="$CORE_DIR" destroy -auto-approve
    echo "✅ Terraform-managed resources destroyed successfully!"
  else
    echo "❌ Core Terraform directory not found at $CORE_DIR. Exiting."
    exit 1
  fi
else
  echo "❌ Core Terraform directory not found. Skipping Terraform destroy."
fi

# ================================
# 🎉 Final Output
# ================================
echo "==============================="
echo "🎉 Cleanup process completed successfully!"
echo "==============================="
