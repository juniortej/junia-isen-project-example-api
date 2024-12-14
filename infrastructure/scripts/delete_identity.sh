#!/bin/bash

# infrastructure/scripts/delete_identity.sh

set -e
set -o pipefail

# Trap and log errors
trap 'echo "❌ An error occurred at line $LINENO while running $BASH_COMMAND. Check the logs above for details."' ERR

# ================================
# 🎉 CONFIGURABLE VARIABLES
# ================================
OWNER_SP_NAME="junia-owner-sp"
DEVELOPER_SP_NAME="junia-developer-sp"
ENV_FILE="../.env"  # Adjust the path if your .env file is located elsewhere

# ================================
# 🔍 Look for existing Service Principals
# ================================
echo "📡 Retrieving App IDs for the following Service Principals:"
echo "1️⃣ Owner SP Name: $OWNER_SP_NAME"
echo "2️⃣ Developer SP Name: $DEVELOPER_SP_NAME"

OWNER_SP_APP_ID=$(az ad sp list --display-name "$OWNER_SP_NAME" --query '[0].appId' -o tsv)
DEVELOPER_SP_APP_ID=$(az ad sp list --display-name "$DEVELOPER_SP_NAME" --query '[0].appId' -o tsv)

if [[ -z "$OWNER_SP_APP_ID" && -z "$DEVELOPER_SP_APP_ID" ]]; then
  echo "❌ No Service Principals found with the names: $OWNER_SP_NAME or $DEVELOPER_SP_NAME"
  exit 0
fi

# ================================
# 🛠️ Function to Remove Variables from .env
# ================================
remove_env_variable() {
  local var_name="$1"
  if grep -q "^${var_name}=" "$ENV_FILE"; then
    echo "🧹 Removing ${var_name} from $ENV_FILE"
    sed -i.bak "/^${var_name}=/d" "$ENV_FILE"
    echo "✅ Removed ${var_name} from $ENV_FILE"
  else
    echo "⚠️ ${var_name} not found in $ENV_FILE. Skipping removal."
  fi
}

# ================================
# 🗑️ Delete the Owner Service Principal
# ================================
if [[ -n "$OWNER_SP_APP_ID" ]]; then
  echo "🗑️ Deleting Owner Service Principal (App ID: $OWNER_SP_APP_ID)"
  az ad sp delete --id "$OWNER_SP_APP_ID"
  echo "✅ Successfully deleted Owner Service Principal: $OWNER_SP_NAME (App ID: $OWNER_SP_APP_ID)"
  
  # Remove related variables from .env
  remove_env_variable "OWNER_SP_NAME"
  remove_env_variable "OWNER_SP_EMAIL"
  remove_env_variable "OWNER_SP_APP_ID"
  remove_env_variable "OWNER_SP_PASSWORD"
  remove_env_variable "OWNER_SP_OBJECT_ID"
else
  echo "⚠️ Owner Service Principal ($OWNER_SP_NAME) not found."
fi

# ================================
# 🗑️ Delete the Developer Service Principal
# ================================
if [[ -n "$DEVELOPER_SP_APP_ID" ]]; then
  echo "🗑️ Deleting Developer Service Principal (App ID: $DEVELOPER_SP_APP_ID)"
  az ad sp delete --id "$DEVELOPER_SP_APP_ID"
  echo "✅ Successfully deleted Developer Service Principal: $DEVELOPER_SP_NAME (App ID: $DEVELOPER_SP_APP_ID)"
  
  # Remove related variables from .env
  remove_env_variable "DEVELOPER_SP_NAME"
  remove_env_variable "DEVELOPER_SP_EMAIL"
  remove_env_variable "DEVELOPER_SP_APP_ID"
  remove_env_variable "DEVELOPER_SP_PASSWORD"
  remove_env_variable "DEVELOPER_SP_OBJECT_ID"
else
  echo "⚠️ Developer Service Principal ($DEVELOPER_SP_NAME) not found."
fi

# ================================
# 🎉 Final Output
# ================================
echo "==============================="
echo "🎉 Deletion process completed successfully!"
echo "==============================="
