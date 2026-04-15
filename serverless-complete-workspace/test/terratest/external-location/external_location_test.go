package test

import (
	"os"
	"path/filepath"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

// ---------------------------------------------------------------------------
// Helper: resolve paths relative to the test folder
// ---------------------------------------------------------------------------

func getTerraformDir(t *testing.T) string {
	cwd, err := os.Getwd()
	require.NoError(t, err)
	return filepath.Clean(filepath.Join(cwd, "..", "..", "..", "infra", "terraform", "main", "wrappers", "external-location"))
}

func getVarFile(t *testing.T) string {
	tfDir := getTerraformDir(t)
	return filepath.Join(tfDir, "aws-SE-99d097-databricks", "us-east-1", "terraform-external-location.auto.tfvars")
}

// ---------------------------------------------------------------------------
// Test 1: Init + Validate
// ---------------------------------------------------------------------------

func TestExternalLocation_InitValidate(t *testing.T) {
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
	t.Log("Init + Validate passed for external-location")
}

// ---------------------------------------------------------------------------
// Test 2: Plan
// ---------------------------------------------------------------------------

func TestExternalLocation_Plan(t *testing.T) {
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
	t.Logf("Plan output length: %d characters", len(planOutput))
	t.Log("Plan passed for external-location")
}

// ---------------------------------------------------------------------------
// Test 3: Apply + Destroy (end-to-end)
// ---------------------------------------------------------------------------

func TestExternalLocation_ApplyDestroy(t *testing.T) {
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
	url := terraform.Output(t, opts, "url")
	require.NotEmpty(t, url, "url should not be empty")

	t.Logf("id = %s", id)
	t.Logf("name = %s", name)
	t.Logf("url = %s", url)
}

// ---------------------------------------------------------------------------
// Test 4: Variable Validation
// ---------------------------------------------------------------------------

func TestExternalLocation_VariableValidation(t *testing.T) {
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
	t.Log("Variable validation passed for external-location")
}

// ---------------------------------------------------------------------------
// Test 5: Input Assertions (no cloud calls)
// ---------------------------------------------------------------------------

func TestExternalLocation_InputAssertions(t *testing.T) {
	terraformDir := getTerraformDir(t)
	varFile := getVarFile(t)

	// Verify terraform directory exists and is accessible
	_, err := os.Stat(terraformDir)
	require.NoError(t, err, "terraform directory should exist")

	// Verify main.tf exists in the terraform directory
	mainTf := filepath.Join(terraformDir, "main.tf")
	_, err = os.Stat(mainTf)
	require.NoError(t, err, "main.tf should exist in terraform directory")

	// Verify variables.tf exists
	varsTf := filepath.Join(terraformDir, "variables.tf")
	_, err = os.Stat(varsTf)
	require.NoError(t, err, "variables.tf should exist in terraform directory")

	// Verify outputs.tf exists
	outputsTf := filepath.Join(terraformDir, "outputs.tf")
	_, err = os.Stat(outputsTf)
	require.NoError(t, err, "outputs.tf should exist in terraform directory")

	// Verify tfvars file exists and is readable
	_, err = os.Stat(varFile)
	require.NoError(t, err, "tfvars file should exist")

	data, err := os.ReadFile(varFile)
	require.NoError(t, err, "tfvars file should be readable")
	assert.NotEmpty(t, string(data), "tfvars file should not be empty")

	t.Log("Input assertions passed for external-location")
}
