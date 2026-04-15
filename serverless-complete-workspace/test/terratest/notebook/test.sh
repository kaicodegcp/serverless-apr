#!/bin/bash
# Test runner for notebook
# Usage: ./test.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"

export TF_VAR_databricks_account_id="${DATABRICKS_ACCOUNT_ID:-test-account-id}"

echo "Running Terratest for notebook..."
cd "$SCRIPT_DIR"

# Run tests
go test -v -timeout 30m -count=1 ./...

echo "Tests completed."
