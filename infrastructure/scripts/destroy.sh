#!/bin/bash

set -e


SCRIPT_DIR="$(dirname "$0")"
CORE_DIR="$SCRIPT_DIR/../core"
BASE_DIR="$SCRIPT_DIR/../base"

echo "❌ Starting full destruction of infrastructure..."

echo "❌ Destroying the core infrastructure..."
terraform -chdir="$CORE_DIR" destroy -auto-approve


echo "❌ Destroying the base infrastructure..."
terraform -chdir="$BASE_DIR" destroy -auto-approve

echo "🎉 Infrastructure destroyed successfully."

