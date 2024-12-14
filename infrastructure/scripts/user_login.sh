#!/bin/bash

set -e
set -o pipefail

trap 'echo "❌ An error occurred at line $LINENO while running $BASH_COMMAND. Check the logs above for details."' ERR

# ================================
# 🎉 Load Environment Variables
# ================================
ENV_FILE="./../.env"

# Check if the .env file exists
if [ -f "$ENV_FILE" ]; then
  echo "🔗 Loading environment variables from $ENV_FILE"
  
  # Export environment variables from the .env file
  set -a
  source "$ENV_FILE"
  set +a

  echo "✅ Loaded environment variables from .env file."
else
  echo "❌ .env file not found at $ENV_FILE. Please ensure it exists and has the correct format."
  exit 1
fi

# ================================
# 🔥 Debug Environment Variables
# ================================
echo "🔍 Debugging loaded environment variables..."
echo "OWNER_SP_APP_ID: $OWNER_SP_APP_ID"
echo "OWNER_SP_PASSWORD: [HIDDEN]"
echo "DEVELOPER_SP_APP_ID: $DEVELOPER_SP_APP_ID"
echo "DEVELOPER_SP_PASSWORD: [HIDDEN]"
echo "AZURE_TENANT_ID: $AZURE_TENANT_ID"
echo "AZURE_SUBSCRIPTION_ID: $AZURE_SUBSCRIPTION_ID"

# ================================
# 🔥 Choose Which SP to Use
# ================================
echo "====================================="
echo "🔐 Select the Service Principal to log in with:"
echo "1️⃣ Owner SP"
echo "2️⃣ Developer SP"
echo "====================================="

# Prompt user for input
read -p "👉 Enter your choice (1 or 2): " CHOICE

if [ "$CHOICE" == "1" ]; then
  SP_APP_ID="$OWNER_SP_APP_ID"
  SP_PASSWORD="$OWNER_SP_PASSWORD"
  echo "🛠️ Logging in with Owner SP (App ID): $SP_APP_ID"
elif [ "$CHOICE" == "2" ]; then
  SP_APP_ID="$DEVELOPER_SP_APP_ID"
  SP_PASSWORD="$DEVELOPER_SP_PASSWORD"
  echo "🛠️ Logging in with Developer SP (App ID): $SP_APP_ID"
else
  echo "❌ Invalid choice. Please enter 1 or 2."
  exit 1
fi

# ================================
# 🔐 Login with SP
# ================================
echo "🔐 Logging in to Azure using Service Principal $SP_APP_ID..."

az login --service-principal \
  --username "$SP_APP_ID" \
  --password "$SP_PASSWORD" \
  --tenant "$AZURE_TENANT_ID" \
  --output none

if [ $? -eq 0 ]; then
  echo "✅ Successfully logged in to Azure using SP (App ID) $SP_APP_ID"
else
  echo "❌ Failed to log in to Azure. Please check your credentials."
  exit 1
fi

# ================================
# 🎉 Final Output
# ================================
echo "====================================="
echo "🎉 Successfully logged in to Azure!"
echo "SP App ID: $SP_APP_ID"
echo "Subscription ID: $AZURE_SUBSCRIPTION_ID"
echo "Tenant ID: $AZURE_TENANT_ID"
echo "====================================="
