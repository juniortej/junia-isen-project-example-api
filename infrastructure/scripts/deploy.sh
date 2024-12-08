#!/bin/bash

set -e

SCRIPT_DIR="$(dirname "$0")"
BASE_DIR="$SCRIPT_DIR/../base"
CORE_DIR="$SCRIPT_DIR/../core"

echo "🚀 Starting full deployment..."

# Deploy Base Infrastructure
echo "🔧 Deploying the base infrastructure..."
./run_base.sh

# Generate and Store VPN Certificates
echo "🔐 Generating and storing VPN certificates..."
./generate_certificates.sh

# Deploy Core Infrastructure
echo "🏗  Deploying the core infrastructure..."
./run_core.sh

echo "🎉 Full deployment completed successfully!"
