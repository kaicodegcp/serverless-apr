#!/bin/bash
set -euo pipefail

echo "Running go mod tidy..."
go mod tidy
echo "Go modules tidied successfully."

# Install dependencies for reporting (optional)
go install gotest.tools/gotestsum@latest || true
go install github.com/tebeka/go-junit-report/v2@latest || true

export PATH="$PATH:$(go env GOPATH)/bin"

# Databricks provider reads auth from DATABRICKS_* env vars.
# Terraform variable is required by some provider versions for MWS resources.
if [[ -z "${TF_VAR_databricks_account_id:-}" ]]; then
  if [[ -n "${DATABRICKS_ACCOUNT_ID:-}" ]]; then
    export TF_VAR_databricks_account_id="$DATABRICKS_ACCOUNT_ID"
  fi
fi

if [[ -z "${TF_VAR_databricks_account_id:-}" ]]; then
  echo "ERROR: databricks_account_id is not set. Export TF_VAR_databricks_account_id or DATABRICKS_ACCOUNT_ID." >&2
  exit 1
fi

mkdir -p test-reports

echo "Running terratest for complete-workspace-serverless..."
if command -v gotestsum >/dev/null 2>&1; then
  gotestsum --format standard-verbose --junitfile test-reports/junit.xml ./... | tee test-reports/test-output.txt
else
  go test -v ./... 2>&1 | tee test-reports/test-output.txt
fi

echo "All tests completed. Reports are available in the test-reports folder."
