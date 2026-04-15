# Wrapper: storage-credential
module "storage_credential" {
  source = "../../modules/storage-credential"

  name = var.name
  comment = var.comment
  owner = var.owner
  aws_iam_role = var.aws_iam_role
  read_only = var.read_only
  skip_validation = var.skip_validation
  force_destroy = var.force_destroy
  force_update = var.force_update
  isolation_mode = var.isolation_mode
}
