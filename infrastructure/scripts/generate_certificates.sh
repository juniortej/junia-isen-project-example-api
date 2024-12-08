#!/bin/bash

set -e

SCRIPT_DIR="$(dirname "$0")"
BASE_DIR="$SCRIPT_DIR/../base"
CERT_DIR="$SCRIPT_DIR/../certs"
ROOT_CERT_NAME="vpnroot"
DAYS_VALID=365

mkdir -p "$CERT_DIR"

echo "🔐 Generating Root Certificate..."

# Generate a private key
openssl genrsa -out "$CERT_DIR/${ROOT_CERT_NAME}.key" 2048

# Generate a self-signed root certificate
openssl req -x509 -new -nodes \
  -key "$CERT_DIR/${ROOT_CERT_NAME}.key" \
  -sha256 -days "$DAYS_VALID" \
  -out "$CERT_DIR/${ROOT_CERT_NAME}.pem" \
  -subj "/C=US/ST=California/L=SanFrancisco/O=YourOrganization/OU=IT/CN=RootCA"

echo "📄 Root Certificate generated at: $CERT_DIR/${ROOT_CERT_NAME}.pem"

# Convert the certificate to base64 and remove any newline characters
if [[ "$OSTYPE" == "darwin"* ]]; then
  # macOS
  BASE64_CERT=$(base64 -b 0 "$CERT_DIR/${ROOT_CERT_NAME}.pem")
else
  # Linux and others
  BASE64_CERT=$(base64 -w 0 "$CERT_DIR/${ROOT_CERT_NAME}.pem")
fi

echo "📡 Retrieving Key Vault Name from base infrastructure outputs..."
KEY_VAULT_NAME=$(terraform -chdir="$BASE_DIR" output -raw key_vault_name)

echo "🔐 Storing Root Certificate in Key Vault..."
az keyvault secret set --vault-name "$KEY_VAULT_NAME" --name "vpn-client-root-cert-data" --value "$BASE64_CERT"

echo "🎉 Root certificate stored in Key Vault as 'vpn-client-root-cert-data'"
echo "✅ Certificate generation completed successfully!"
