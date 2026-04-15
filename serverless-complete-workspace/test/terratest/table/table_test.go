package test

import (
	"os"
	"path/filepath"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func getTerraformDir(t *testing.T) string {
	cwd, err := os.Getwd()
	require.NoError(t, err)
	return filepath.Clean(filepath.Join(cwd, "..", "..", "..", "infra", "terraform", "main", "wrappers", "table"))
}

func getVarFile(t *testing.T) string {
	tfDir := getTerraformDir(t)
	return filepath.Join(tfDir, "aws-SE-99d097-databricks", "us-east-1", "terraform-table.auto.tfvars")
}

func TestTable_InitValidate(t *testing.T) {
	terraformDir := getTerraformDir(t)
	varFile := getVarFile(t)

	opts := &terraform.Options{
		TerraformDir: terraformDir,
		VarFiles:     []string{varFile},
		NoColor:      true,
	}

	terraform.Init(t, opts)
	result := terraform.Validate(t, opts)
	require.NotEmpty(t, result, "terraform validate should produce output")
	t.Log("Init + Validate passed for table")
}

func TestTable_Plan(t *testing.T) {
	terraformDir := getTerraformDir(t)
	varFile := getVarFile(t)

	opts := &terraform.Options{
		TerraformDir: terraformDir,
		VarFiles:     []string{varFile},
		NoColor:      true,
	}

	terraform.Init(t, opts)
	planOutput := terraform.Plan(t, opts)
	require.NotEmpty(t, planOutput, "terraform plan should produce output")
	t.Log("Plan passed for table")
}

func TestTable_ApplyDestroy(t *testing.T) {
	terraformDir := getTerraformDir(t)
	varFile := getVarFile(t)

	opts := &terraform.Options{
		TerraformDir: terraformDir,
		VarFiles:     []string{varFile},
		NoColor:      true,
	}

	if os.Getenv("KEEP_RESOURCES") != "true" {
		defer terraform.Destroy(t, opts)
	}

	terraform.InitAndApply(t, opts)

	id := terraform.Output(t, opts, "id")
	require.NotEmpty(t, id, "id should not be empty")
	name := terraform.Output(t, opts, "name")
	require.NotEmpty(t, name, "name should not be empty")
	fullName := terraform.Output(t, opts, "full_name")
	require.NotEmpty(t, fullName, "full_name should not be empty")

	t.Logf("id = %s", id)
	t.Logf("name = %s", name)
	t.Logf("full_name = %s", fullName)
}

func TestTable_VariableValidation(t *testing.T) {
	terraformDir := getTerraformDir(t)
	varFile := getVarFile(t)

	opts := &terraform.Options{
		TerraformDir: terraformDir,
		VarFiles:     []string{varFile},
		NoColor:      true,
	}

	_, err := os.Stat(varFile)
	require.NoError(t, err, "tfvars file should exist")

	terraform.Init(t, opts)
	result := terraform.Validate(t, opts)
	require.NotEmpty(t, result, "terraform validate should succeed")
	t.Log("Variable validation passed for table")
}

func TestTable_InputAssertions(t *testing.T) {
	terraformDir := getTerraformDir(t)

	opts := &terraform.Options{
		TerraformDir: terraformDir,
		NoColor:      true,
	}

	assert.NotNil(t, opts.TerraformDir)
	assert.NotEmpty(t, opts.TerraformDir)
	assert.NotNil(t, opts.Vars["catalog_name"], "catalog_name should be set")
	assert.NotNil(t, opts.Vars["schema_name"], "schema_name should be set")
	assert.NotNil(t, opts.Vars["name"], "name should be set")

	t.Log("Input assertions passed for table")
}
