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
	return filepath.Clean(filepath.Join(cwd, "..", "..", "..", "infra", "terraform", "main", "wrappers", "mws-network-connectivity-config"))
}

func getVarFile(t *testing.T) string {
	tfDir := getTerraformDir(t)
	return filepath.Join(tfDir, "aws-SE-99d097-databricks", "us-east-1", "terraform-mws-network-connectivity-config.auto.tfvars")
}

// ---------------------------------------------------------------------------
// Test 1: Init + Validate
// ---------------------------------------------------------------------------

func TestMwsNetworkConnectivityConfig_InitValidate(t *testing.T) {
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
	t.Log("Init + Validate passed for mws-network-connectivity-config")
}

// ---------------------------------------------------------------------------
// Test 2: Plan
// ---------------------------------------------------------------------------

func TestMwsNetworkConnectivityConfig_Plan(t *testing.T) {
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
	t.Log("Plan passed for mws-network-connectivity-config")
}

// ---------------------------------------------------------------------------
// Test 3: Apply + Destroy (end-to-end)
// ---------------------------------------------------------------------------

func TestMwsNetworkConnectivityConfig_ApplyDestroy(t *testing.T) {
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

	network_connectivity_config_id := terraform.Output(t, opts, "network_connectivity_config_id")
	require.NotEmpty(t, network_connectivity_config_id, "network_connectivity_config_id should not be empty")
	id := terraform.Output(t, opts, "id")
	require.NotEmpty(t, id, "id should not be empty")
	egress_config := terraform.Output(t, opts, "egress_config")
	require.NotEmpty(t, egress_config, "egress_config should not be empty")
	nlb_private_endpoint_rule_id := terraform.Output(t, opts, "nlb_private_endpoint_rule_id")
	require.NotEmpty(t, nlb_private_endpoint_rule_id, "nlb_private_endpoint_rule_id should not be empty")
	nlb_private_endpoint_connection_state := terraform.Output(t, opts, "nlb_private_endpoint_connection_state")
	require.NotEmpty(t, nlb_private_endpoint_connection_state, "nlb_private_endpoint_connection_state should not be empty")

	t.Logf("network_connectivity_config_id = %s", network_connectivity_config_id)
	t.Logf("id = %s", id)
	t.Logf("egress_config = %s", egress_config)
	t.Logf("nlb_private_endpoint_rule_id = %s", nlb_private_endpoint_rule_id)
	t.Logf("nlb_private_endpoint_connection_state = %s", nlb_private_endpoint_connection_state)
}

// ---------------------------------------------------------------------------
// Test 4: Variable Validation
// ---------------------------------------------------------------------------

func TestMwsNetworkConnectivityConfig_VariableValidation(t *testing.T) {
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
	t.Log("Variable validation passed for mws-network-connectivity-config")
}

// ---------------------------------------------------------------------------
// Test 5: Input Assertions (no cloud calls)
// ---------------------------------------------------------------------------

func TestMwsNetworkConnectivityConfig_InputAssertions(t *testing.T) {
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

	t.Log("Input assertions passed for mws-network-connectivity-config")
}
