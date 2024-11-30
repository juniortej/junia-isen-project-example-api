#!/bin/bash

set -e

ENV_FILE="shop-app/.env"

# Ensure that the .env file exists
if [ -f "$ENV_FILE" ]; then
  echo "Loading environment variables from .env file..."
  export $(grep -v '^#' "$ENV_FILE" | xargs)
else
  echo ".env file not found at $ENV_FILE. Please create a .env file with the required environment variables."
  exit 1
fi

# Check if required environment variables are loaded
if [ -z "$TF_VAR_admin_password" ] || [ -z "$TF_VAR_admin_username" ] || [ -z "$TF_VAR_database_name" ] || [ -z "$TF_VAR_vpn_client_root_certificate_public_cert_data" ]; then
  echo "Error: Missing required environment variables in .env file."
  exit 1
fi

echo "Navigating to the 'infrastructure' directory..."
cd infrastructure

echo "Formatting Terraform files..."
terraform fmt

echo "Initializing Terraform..."
terraform init

echo "Validating Terraform configuration..."
terraform validate

echo "Planning Terraform deployment..."
terraform plan -out=tfplan

echo "Applying Terraform deployment..."
terraform apply tfplan

echo "Cleaning up..."
rm tfplan

echo "Fetching Terraform outputs and updating .env file..."
cd ..

# Retrieve outputs from Terraform
POSTGRES_HOST=$(terraform -chdir=infrastructure output -raw postgresql_server_fqdn)
POSTGRES_DB=$(terraform -chdir=infrastructure output -raw postgresql_database_name)
POSTGRES_USER=$(terraform -chdir=infrastructure output -raw postgresql_administrator_login)
POSTGRES_PORT=5432  # Default PostgreSQL port
VPN_PUBLIC_IP=$(terraform -chdir=infrastructure output -raw vpn_gateway_public_ip)

echo "Updating .env file with database connection details..."

# Remove existing entries to avoid duplicates
sed -i '/^POSTGRES_HOST=/d' "$ENV_FILE"
sed -i '/^POSTGRES_DB=/d' "$ENV_FILE"
sed -i '/^POSTGRES_USER=/d' "$ENV_FILE"
sed -i '/^POSTGRES_PASSWORD=/d' "$ENV_FILE"
sed -i '/^POSTGRES_PORT=/d' "$ENV_FILE"
sed -i '/^VPN_PUBLIC_IP=/d' "$ENV_FILE"
sed -i '/^VPN_CLIENT_ROOT_CERT=/d' "$ENV_FILE"

# Append new variables to the .env file
cat >> "$ENV_FILE" <<EOL

POSTGRES_HOST=$POSTGRES_HOST
POSTGRES_DB=$POSTGRES_DB
POSTGRES_USER=${POSTGRES_USER}@${POSTGRES_HOST}
POSTGRES_PASSWORD=$TF_VAR_admin_password
POSTGRES_PORT=$POSTGRES_PORT
VPN_PUBLIC_IP=$VPN_PUBLIC_IP
VPN_CLIENT_ROOT_CERT=$TF_VAR_vpn_client_root_certificate_public_cert_data
EOL

echo "Deployment completed successfully!"
