# Terratest: group

## Prerequisites

- Go >= 1.21
- Terraform >= 1.5.0
- Required environment variables set (see top-level README)

## Run Tests

```bash
cd test/terratest/group
chmod +x test.sh
./test.sh
```

## Test Coverage

| Test | Description |
|------|-------------|
| InitValidate | terraform init + validate |
| Plan | terraform plan |
| ApplyDestroy | Full apply/destroy with KEEP_RESOURCES support |
| VariableValidation | Validates tfvars file parsing |
| InputAssertions | Parameter-only assertions (no cloud calls) |

## Keep Resources

```bash
export KEEP_RESOURCES=true
./test.sh
```
