#!/bin/bash

# ================================
# 🚀 **Set Fail-Safe Options**
# ================================
set -e
set -o pipefail

trap 'echo "❌ An error occurred at line $LINENO while running $BASH_COMMAND. Check the logs above for details."' ERR

# ================================
# 🎉 CONFIGURABLE VARIABLES
# ================================
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="$SCRIPT_DIR/../.env"
CORE_DIR="$SCRIPT_DIR/../core"

# ================================
# 🛠️ **Utility Functions**
# ================================

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

check_azure_authentication() {
  echo "🔐 Checking Azure authentication..."
  AZURE_SUBSCRIPTION_ID_CURRENT=$(az account show --query "id" -o tsv)
  if [[ -z "$AZURE_SUBSCRIPTION_ID_CURRENT" ]]; then
    echo "❌ You are not authenticated to Azure. Please run 'az login' to authenticate."
    exit 1
  fi
  echo "✅ Authenticated to Azure Subscription: $AZURE_SUBSCRIPTION_ID_CURRENT"
}

# ================================
# 🔍 **Retrieve Service Principal Information**
# ================================
retrieve_sp_info() {
  echo "📡 Retrieving Service Principal information from .env..."

  if [[ -f "$ENV_FILE" ]]; then
    set -a
    source "$ENV_FILE"
    set +a
  else
    echo "❌ .env file not found at $ENV_FILE. Exiting."
    exit 1
  fi

  OWNER_SP_APP_ID="${OWNER_SP_APP_ID}"
  DEVELOPER_SP_APP_ID="${DEVELOPER_SP_APP_ID}"
  GITHUB_TOKEN="${GITHUB_TOKEN}"

  REQUIRED_VARS=("OWNER_SP_APP_ID" "DEVELOPER_SP_APP_ID" "GITHUB_TOKEN")
  for var in "${REQUIRED_VARS[@]}"; do
    if [[ -z "${!var}" ]]; then
      echo "❌ Environment variable '$var' is not set in $ENV_FILE."
      exit 1
    fi
  done

  echo "✅ Service Principal App IDs and GitHub Token retrieved successfully."
}

# ================================
# 🛠️ **Main Cleanup Process**
# ================================
main_cleanup() {
  check_required_tools
  check_azure_authentication

  retrieve_sp_info

  if [[ -d "$CORE_DIR" ]]; then
    echo "🛠️ Destroying Terraform-managed resources..."
    terraform -chdir="$CORE_DIR" destroy \
      -auto-approve \
      -var "developer_object_id=$DEVELOPER_SP_OBJECT_ID" \
      -var "owner_object_id=$OWNER_SP_OBJECT_ID" \
      -var "context_access_token=$GITHUB_TOKEN"
    echo "✅ Terraform-managed resources destroyed successfully!"
  else
    echo "❌ Core Terraform directory not found at $CORE_DIR. Exiting."
    exit 1
  fi

  if [[ -n "$OWNER_SP_APP_ID" ]]; then
    echo "🔨 Deleting Owner Service Principal (App ID: $OWNER_SP_APP_ID)..."
    az ad sp delete --id "$OWNER_SP_APP_ID" && echo "✅ Owner Service Principal deleted successfully!"
  fi

  if [[ -n "$DEVELOPER_SP_APP_ID" ]]; then
    echo "🔨 Deleting Developer Service Principal (App ID: $DEVELOPER_SP_APP_ID)..."
    az ad sp delete --id "$DEVELOPER_SP_APP_ID" && echo "✅ Developer Service Principal deleted successfully!"
  fi

  echo "🧹 Cleaning up Service Principal variables from .env..."
  sed -i '/OWNER_SP_APP_ID=/d' "$ENV_FILE"
  sed -i '/DEVELOPER_SP_APP_ID=/d' "$ENV_FILE"
  sed -i '/GITHUB_TOKEN=/d' "$ENV_FILE"
  echo "✅ Service Principal and GitHub Token variables removed from .env."

  # ================================
  # 🎉 Final Output
  # ================================
  echo "==============================="
  echo "🎉 Cleanup process completed successfully!"
  echo "==============================="
}

# ================================
# 🚀 **Execute Main Cleanup**
# ================================
main_cleanup
