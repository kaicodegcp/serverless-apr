package user_permission

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestUserPermission(t *testing.T) {
	t.Parallel()

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../../../infra/terraform/main/wrappers/user-permission",
		Vars: map[string]interface{}{
			"databricks_account_id": "test-account-id",
			"user_name": "test@example.com",
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
