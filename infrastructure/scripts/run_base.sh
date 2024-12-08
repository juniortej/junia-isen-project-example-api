#!/bin/bash

set -e

SCRIPT_DIR="$(dirname "$0")"
BASE_DIR="$SCRIPT_DIR/../base"

echo "🚀 Running base infrastructure setup..."

echo "📂 Running 'terraform fmt' to format the configuration files..."
terraform fmt -recursive "$BASE_DIR"

echo "📦 Running 'terraform init' to initialize the provider plugins..."
terraform init "$BASE_DIR"

echo "✅ Running 'terraform validate' to ensure the configuration is valid..."
terraform validate "$BASE_DIR"

echo "📋 Running 'terraform plan' to preview the changes..."
terraform plan -out="$BASE_DIR/tfplan" "$BASE_DIR"

echo "⚡ Applying the Terraform configuration... (Only type 'yes' to approve)"
terraform apply "$BASE_DIR/tfplan"

echo "🧹 Cleaning up the plan file..."
rm "$BASE_DIR/tfplan"

echo "🎉 Base infrastructure deployed successfully!"
echo "You can now use the outputs for next steps (e.g., configuring backend in core folder)."
