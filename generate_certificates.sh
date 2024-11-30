#!/bin/bash

set -e

# Variables
ROOT_CERT_DIR="./certs"
ROOT_CERT_NAME="vpnroot"
ENV_FILE="shop-app/.env"
DAYS_VALID=365  # Certificate validity period in days

# Ensure the directory for certificates exists
mkdir -p "$ROOT_CERT_DIR"

echo "Generating Root Certificate..."

# 1. Generate Root Certificate Private Key
openssl genrsa -out "$ROOT_CERT_DIR/${ROOT_CERT_NAME}.key" 2048

# 2. Create the Root Certificate (self-signed)
openssl req -x509 -new -nodes -key "$ROOT_CERT_DIR/${ROOT_CERT_NAME}.key" \
  -sha256 -days "$DAYS_VALID" -out "$ROOT_CERT_DIR/${ROOT_CERT_NAME}.pem" \
  -subj "/C=US/ST=California/L=SanFrancisco/O=YourOrganization/OU=IT/CN=RootCA"

echo "Root Certificate generated at: $ROOT_CERT_DIR/${ROOT_CERT_NAME}.pem"

# 3. Base64 Encode the Root Certificate (remove newlines for Azure compatibility)
BASE64_CERT=$(cat "$ROOT_CERT_DIR/${ROOT_CERT_NAME}.pem" | base64 | tr -d '\n')

echo "Base64-encoded Root Certificate:"
echo "$BASE64_CERT"

# Ensure the .env file exists
if [ ! -f "$ENV_FILE" ]; then
  echo ".env file not found at $ENV_FILE. Creating one..."
  touch "$ENV_FILE"
fi

echo "Updating .env file with Root Certificate data..."

# Update the .env file with the Base64-encoded certificate
if grep -q "TF_VAR_vpn_client_root_certificate_public_cert_data" "$ENV_FILE"; then
  # Replace existing line
  sed -i "s|^TF_VAR_vpn_client_root_certificate_public_cert_data=.*|TF_VAR_vpn_client_root_certificate_public_cert_data=$BASE64_CERT|" "$ENV_FILE"
else
  # Append new line
  echo "TF_VAR_vpn_client_root_certificate_public_cert_data=$BASE64_CERT" >> "$ENV_FILE"
fi

echo "Root certificate information added to $ENV_FILE"

echo "Certificate generation completed successfully!"
