#!/bin/bash

set -e
set -o pipefail

trap 'echo "❌ An error occurred at line $LINENO while running $BASH_COMMAND. Check the logs above for details."' ERR

# ================================
# 🚀 AUTO-DETECT VARIABLES
# ================================
echo "📡 Retrieving the current Tenant ID and Subscription ID..."
AZURE_TENANT_ID=$(az account show --query "tenantId" -o tsv)
AZURE_SUBSCRIPTION_ID=$(az account show --query "id" -o tsv)

if [[ -z "$AZURE_TENANT_ID" || -z "$AZURE_SUBSCRIPTION_ID" ]]; then
  echo "❌ Failed to retrieve Tenant ID or Subscription ID. Make sure you are authenticated."
  exit 1
fi

echo "🔑 Azure Tenant ID: $AZURE_TENANT_ID"
echo "📜 Azure Subscription ID: $AZURE_SUBSCRIPTION_ID"

# ================================
# 🎉 CONFIGURABLE VARIABLES
# ================================
OWNER_SP_NAME="junia-owner-sp"
DEVELOPER_SP_NAME="junia-developer-sp"
ENV_FILE="./../.env"

# ================================
# 🛠️ Function to Check if SP Exists
# ================================
check_sp_exists() {
  local sp_name="$1"
  az ad sp list --display-name "$sp_name" --query "length(@)" -o tsv
}

# ================================
# 🛠️ Function to Assign Role
# ================================
assign_role() {
  local principal_id="$1"
  local role="$2"
  local scope="$3"
  
  echo "🔧 Assigning role '$role' to principal ID '$principal_id' on scope '$scope'..."
  az role assignment create \
    --assignee "$principal_id" \
    --role "$role" \
    --scope "$scope" \
    --only-show-errors
}

# ================================
# 🛠️ Create the Owner SP (Full Control)
# ================================
echo "📋 Creating Service Principal (SP) for Owner: $OWNER_SP_NAME"

# Check if Owner SP exists
OWNER_SP_EXISTS=$(check_sp_exists "$OWNER_SP_NAME")
if [[ "$OWNER_SP_EXISTS" -gt 0 ]]; then
  echo "⚠️ Service Principal '$OWNER_SP_NAME' already exists. Deleting it first..."
  # Retrieve existing App ID
  OWNER_SP_APP_ID=$(az ad sp list --display-name "$OWNER_SP_NAME" --query "[0].appId" -o tsv)
  az ad sp delete --id "$OWNER_SP_APP_ID" || true
  sleep 5
fi

# Create Owner SP with Owner role
OWNER_SP_OUTPUT=$(az ad sp create-for-rbac \
  --name "$OWNER_SP_NAME" \
  --role "Owner" \
  --scopes "/subscriptions/$AZURE_SUBSCRIPTION_ID" \
  --query "{appId: appId, password: password, tenant: tenant}" \
  -o json)

OWNER_SP_APP_ID=$(echo "$OWNER_SP_OUTPUT" | jq -r '.appId')
OWNER_SP_PASSWORD=$(echo "$OWNER_SP_OUTPUT" | jq -r '.password')

if [[ -z "$OWNER_SP_APP_ID" ]]; then
  echo "❌ Failed to create Owner Service Principal."
  exit 1
fi

# Introduce a delay to allow Azure to propagate the SP creation
sleep 10

# Retrieve the Object ID of the Owner SP
OWNER_OBJECT_ID=$(az ad sp show --id "$OWNER_SP_APP_ID" --query "id" -o tsv || echo "")

if [[ -z "$OWNER_OBJECT_ID" ]]; then
  echo "❌ Failed to retrieve Object ID for Owner SP ($OWNER_SP_NAME)."
  exit 1
fi

# Note: Service Principals typically do not have UPNs like users. This is a custom assignment.
OWNER_SP_EMAIL="$OWNER_SP_NAME@$AZURE_TENANT_ID"

echo "✅ Owner Service Principal created successfully!"
echo "🔑 App ID: $OWNER_SP_APP_ID"
echo "🔑 Object ID: $OWNER_OBJECT_ID"
echo "🔑 Email (UPN): $OWNER_SP_EMAIL"
echo "🔑 Password: (hidden)"
echo "🔑 Tenant: $AZURE_TENANT_ID"

# ================================
# 🛠️ Create the Developer SP (Limited Permissions)
# ================================
echo "📋 Creating Service Principal (SP) for Developer: $DEVELOPER_SP_NAME"

# Check if Developer SP exists
DEVELOPER_SP_EXISTS=$(check_sp_exists "$DEVELOPER_SP_NAME")
if [[ "$DEVELOPER_SP_EXISTS" -gt 0 ]]; then
  echo "⚠️ Service Principal '$DEVELOPER_SP_NAME' already exists. Deleting it first..."
  # Retrieve existing App ID
  DEVELOPER_SP_APP_ID=$(az ad sp list --display-name "$DEVELOPER_SP_NAME" --query "[0].appId" -o tsv)
  az ad sp delete --id "$DEVELOPER_SP_APP_ID" || true
  sleep 5
fi

# Create Developer SP with Contributor role
DEVELOPER_SP_OUTPUT=$(az ad sp create-for-rbac \
  --name "$DEVELOPER_SP_NAME" \
  --role "Contributor" \
  --scopes "/subscriptions/$AZURE_SUBSCRIPTION_ID" \
  --query "{appId: appId, password: password, tenant: tenant}" \
  -o json)

DEVELOPER_SP_APP_ID=$(echo "$DEVELOPER_SP_OUTPUT" | jq -r '.appId')
DEVELOPER_SP_PASSWORD=$(echo "$DEVELOPER_SP_OUTPUT" | jq -r '.password')

if [[ -z "$DEVELOPER_SP_APP_ID" ]]; then
  echo "❌ Failed to create Developer Service Principal."
  exit 1
fi

# Introduce a delay to allow Azure to propagate the SP creation
sleep 10

# Retrieve the Object ID of the Developer SP
DEVELOPER_OBJECT_ID=$(az ad sp show --id "$DEVELOPER_SP_APP_ID" --query "id" -o tsv || echo "")

if [[ -z "$DEVELOPER_OBJECT_ID" ]]; then
  echo "❌ Failed to retrieve Object ID for Developer SP ($DEVELOPER_SP_NAME)."
  exit 1
fi

DEVELOPER_SP_EMAIL="$DEVELOPER_SP_NAME@$AZURE_TENANT_ID"

echo "✅ Developer Service Principal created successfully!"
echo "🔑 App ID: $DEVELOPER_SP_APP_ID"
echo "🔑 Object ID: $DEVELOPER_OBJECT_ID"
echo "🔑 Email (UPN): $DEVELOPER_SP_EMAIL"
echo "🔑 Password: (hidden)"
echo "🔑 Tenant: $AZURE_TENANT_ID"

# ================================
# 🛠️ Assign Additional Roles to Developer SP
# ================================
echo "📋 Assigning 'User Access Administrator' role to Developer SP..."

assign_role "$DEVELOPER_OBJECT_ID" "User Access Administrator" "/subscriptions/$AZURE_SUBSCRIPTION_ID"

echo "✅ 'User Access Administrator' role assigned to Developer SP."

# Assign "Key Vault Secrets Officer" role to Developer SP (will be handled in Terraform)

# ================================
# 🎉 Save SP Credentials to .env file
# ================================
echo "💾 Saving credentials to $ENV_FILE..."
cat <<EOF > "$ENV_FILE"
# Service Principal for Owner
OWNER_SP_NAME="$OWNER_SP_NAME"
OWNER_SP_EMAIL="$OWNER_SP_EMAIL"
OWNER_SP_APP_ID="$OWNER_SP_APP_ID"
OWNER_SP_PASSWORD="$OWNER_SP_PASSWORD"
OWNER_SP_OBJECT_ID="$OWNER_OBJECT_ID"

# Service Principal for Developer
DEVELOPER_SP_NAME="$DEVELOPER_SP_NAME"
DEVELOPER_SP_EMAIL="$DEVELOPER_SP_EMAIL"
DEVELOPER_SP_APP_ID="$DEVELOPER_SP_APP_ID"
DEVELOPER_SP_PASSWORD="$DEVELOPER_SP_PASSWORD"
DEVELOPER_SP_OBJECT_ID="$DEVELOPER_OBJECT_ID"

# Azure Tenant and Subscription
AZURE_TENANT_ID="$AZURE_TENANT_ID"
AZURE_SUBSCRIPTION_ID="$AZURE_SUBSCRIPTION_ID"
EOF

# Verify if .env file exists
if [[ -f "$ENV_FILE" ]]; then
  echo "✅ .env file created successfully at $ENV_FILE"
else
  echo "❌ Failed to create the .env file. Please check your file permissions."
  exit 1
fi

# ================================
# 🎉 Final Output
# ================================
echo "==============================="
echo "🎉 Service Principals Created Successfully!"
echo "==============================="

echo "🔑 **Owner Service Principal**"
echo "Email: $OWNER_SP_EMAIL"
echo "App ID: $OWNER_SP_APP_ID"
echo "Object ID: $OWNER_OBJECT_ID"
echo "Tenant: $AZURE_TENANT_ID"

echo "🔑 **Developer Service Principal**"
echo "Email: $DEVELOPER_SP_EMAIL"
echo "App ID: $DEVELOPER_SP_APP_ID"
echo "Object ID: $DEVELOPER_OBJECT_ID"
echo "Tenant: $AZURE_TENANT_ID"

echo "==============================="
echo "✅ Credentials saved to: $ENV_FILE"
echo "🔒 Keep this file safe and do not commit it to version control."
echo "==============================="
