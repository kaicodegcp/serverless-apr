# Provider config relies on environment variables:
#   AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_DEFAULT_REGION
#   DATABRICKS_HOST, DATABRICKS_ACCOUNT_ID
#   DATABRICKS_CLIENT_ID, DATABRICKS_CLIENT_SECRET
provider "aws" {
  region = var.aws_region
}

provider "databricks" {
  alias      = "mws"
  host       = "https://accounts.cloud.databricks.com"
  account_id = var.databricks_account_id
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}
