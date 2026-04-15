# Provider config relies on environment variables:
#   DATABRICKS_HOST
#   DATABRICKS_ACCOUNT_ID
#   DATABRICKS_CLIENT_ID
#   DATABRICKS_CLIENT_SECRET
provider "databricks" {
  alias      = "mws"
  host       = "https://accounts.cloud.databricks.com"
  account_id = var.databricks_account_id
}
