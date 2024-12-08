#!/bin/bash

set -e

SCRIPT_DIR="$(dirname "$0")"
CORE_DIR="$SCRIPT_DIR/../core"

echo "📦 Formatting Terraform configuration files..."
terraform fmt -recursive "$CORE_DIR"

echo "🔄 Initializing Terraform..."
terraform init "$CORE_DIR"

echo "✅ Validating Terraform configuration..."
terraform validate "$CORE_DIR"

echo "📝 Planning Terraform deployment..."
terraform plan -out="$CORE_DIR/tfplan" "$CORE_DIR"

echo "🚀 Applying Terraform deployment..."
terraform apply "$CORE_DIR/tfplan"

echo "🧹 Cleaning up plan file..."
rm "$CORE_DIR/tfplan"

echo "🎉 Core infrastructure deployed successfully!"
echo "Use Terraform outputs or Key Vault secrets for further configuration."
