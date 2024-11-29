#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Ensure that the .env file exists
if [ -f .env ]; then
  echo "Loading environment variables from .env file..."
  export $(grep -v '^#' .env | xargs)
else
  echo ".env file not found. Please create a .env file with the required environment variables."
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

# Use the existing admin password from the environment variable
if [ -z "$TF_VAR_admin_password" ]; then
  echo "Error: TF_VAR_admin_password is not set in the .env file."
  exit 1
fi
POSTGRES_PASSWORD="$TF_VAR_admin_password"

echo "Updating .env file with database connection details..."

# Update the .env file
cat > .env <<EOL
TF_VAR_admin_password=$TF_VAR_admin_password
TF_VAR_admin_username=$POSTGRES_USER

POSTGRES_HOST=$POSTGRES_HOST
POSTGRES_DB=$POSTGRES_DB
POSTGRES_USER=${POSTGRES_USER}@${POSTGRES_HOST}
POSTGRES_PASSWORD=$POSTGRES_PASSWORD
POSTGRES_PORT=$POSTGRES_PORT
EOL

echo "Deployment completed successfully!"
