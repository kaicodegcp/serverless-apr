# Table Terratest

Tests for the `table` wrapper module that provisions tables in Unity Catalog (catalog.schema.table).

## Tests

| Test | Description |
|------|-------------|
| `TestTable_InitValidate` | Runs `terraform init` + `terraform validate` |
| `TestTable_Plan` | Runs `terraform plan` and verifies output |
| `TestTable_ApplyDestroy` | Full lifecycle: init, apply, verify outputs, destroy |
| `TestTable_VariableValidation` | Validates tfvars file exists and config is valid |
| `TestTable_InputAssertions` | Asserts required input variables are set |
