# =============================================================================
# Provider Configuration
# =============================================================================
# AWS provider config relies on environment variables or instance profile:
#   AWS_ACCESS_KEY_ID
#   AWS_SECRET_ACCESS_KEY
#   AWS_DEFAULT_REGION
#
# Databricks Account-level provider config relies on environment variables:
#   DATABRICKS_HOST           (e.g. https://accounts.cloud.databricks.com)
#   DATABRICKS_ACCOUNT_ID
#   DATABRICKS_CLIENT_ID
#   DATABRICKS_CLIENT_SECRET
#
# This keeps secrets out of tfvars and repo history.
# =============================================================================

provider "aws" {
  region = var.aws_region
}

provider "databricks" {
  alias      = "mws"
  host       = "https://accounts.cloud.databricks.com"
  account_id = var.databricks_account_id
}
