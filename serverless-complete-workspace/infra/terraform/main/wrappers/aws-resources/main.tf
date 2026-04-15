# Wrapper: aws-resources
module "aws_resources" {
  source = "../../modules/aws-resources"

  bucket_name               = var.bucket_name
  name_prefix               = var.name_prefix
  databricks_account_id     = var.databricks_account_id
  databricks_aws_account_id = var.databricks_aws_account_id
  create_cross_account_role = var.create_cross_account_role
  force_destroy             = var.force_destroy
  tags                      = var.tags
}
