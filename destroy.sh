#!/bin/bash

set -e

echo "Navigating to the 'infrastructure' directory..."
cd "$(dirname "$0")/infrastructure"

echo "Refreshing Terraform state..."
terraform refresh

echo "Loading resource names from Terraform outputs..."

# Get resource group name from Terraform output
RESOURCE_GROUP_NAME=$(terraform output -raw resource_group_name)
VNET_NAME=$(terraform output -raw vnet_name)
DB_SUBNET_NAME=$(terraform output -raw db_subnet_name)

# Verify that required variables are not empty
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
