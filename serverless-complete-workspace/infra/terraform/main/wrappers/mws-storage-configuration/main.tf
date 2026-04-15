# Wrapper: mws-storage-configuration
module "mws_storage_configuration" {
  source = "../../modules/mws-storage-configuration"

  account_id = var.account_id
  storage_configuration_name = var.storage_configuration_name
  bucket_name = var.bucket_name
}
