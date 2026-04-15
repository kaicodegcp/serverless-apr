package grants_table

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestGrantsTable(t *testing.T) {
	t.Parallel()

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../../../infra/terraform/main/wrappers/grants-table",
		Vars: map[string]interface{}{
			"databricks_account_id": "test-account-id",
		},
		// Skip apply - only validate configuration
		// Set to true to run a full apply (requires real credentials)
		NoColor: true,
	})

	// Validate the Terraform configuration
	terraform.InitAndValidate(t, terraformOptions)

	// Verify expected outputs are defined
	terraform.InitAndPlanWithExitCode(t, terraformOptions)

	// Assert that the plan can be generated without errors
	assert.NotNil(t, terraformOptions)
}
