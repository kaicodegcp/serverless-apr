# Autoloader Terratest

Tests for the `autoloader` wrapper module that provisions SQS event notification and DLT pipeline for loading data from S3 into catalog.schema.table.

## Tests

| Test | Description |
|------|-------------|
| `TestAutoloader_InitValidate` | Runs `terraform init` + `terraform validate` |
| `TestAutoloader_Plan` | Runs `terraform plan` and verifies output |
| `TestAutoloader_ApplyDestroy` | Full lifecycle: init, apply, verify outputs, destroy |
| `TestAutoloader_VariableValidation` | Validates tfvars file exists and config is valid |
| `TestAutoloader_InputAssertions` | Asserts required input variables are set |
