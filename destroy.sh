#!/bin/bash

set -e

ENV_FILE="shop-app/.env"

# Ensure that the .env file exists
if [ -f "$ENV_FILE" ]; then
  echo "Loading environment variables from .env file..."
  export $(grep -v '^#' "$ENV_FILE" | xargs)
else
  echo ".env file not found at $ENV_FILE. Please ensure the .env file exists with the required environment variables."
  exit 1
fi

echo "Navigating to the 'infrastructure' directory..."
cd infrastructure

echo "Refreshing Terraform state..."
terraform refresh

echo "Loading resource names from Terraform outputs..."

# Get resource group name from Terraform output
RESOURCE_GROUP_NAME=$(terraform output -raw resource_group_name)
VNET_NAME=$(terraform output -raw vnet_name)
DB_SUBNET_NAME=$(terraform output -raw db_subnet_name)

# Verify that required outputs are not empty
if [ -z "$RESOURCE_GROUP_NAME" ] || [ -z "$VNET_NAME" ] || [ -z "$DB_SUBNET_NAME" ]; then
  echo "Error: Failed to retrieve necessary outputs from Terraform state."
  exit 1
fi

echo "Resource Group Name: $RESOURCE_GROUP_NAME"
echo "Virtual Network Name: $VNET_NAME"
echo "Database Subnet Name: $DB_SUBNET_NAME"

echo "Running 'terraform destroy' to destroy the infrastructure..."
terraform destroy -auto-approve

echo "Infrastructure destroyed successfully."

echo "Navigating back to the project root..."
cd ..

echo "Removing database connection details from .env file..."

# Remove the deployment-specific variables added by deploy.sh
sed -i '/^POSTGRES_HOST=/d' "$ENV_FILE"
sed -i '/^POSTGRES_DB=/d' "$ENV_FILE"
sed -i '/^POSTGRES_USER=/d' "$ENV_FILE"
sed -i '/^POSTGRES_PASSWORD=/d' "$ENV_FILE"
sed -i '/^POSTGRES_PORT=/d' "$ENV_FILE"
sed -i '/^VPN_PUBLIC_IP=/d' "$ENV_FILE"
sed -i '/^VPN_CLIENT_ROOT_CERT=/d' "$ENV_FILE"

echo "Removed database connection details from .env file."

echo "Destroy script completed successfully."
