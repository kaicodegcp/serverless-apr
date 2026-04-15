# Wrapper: pipeline
# Creates a DLT pipeline with owner group permissions

module "pipeline" {
  source = "../../modules/pipeline"

  name                  = var.name
  storage               = var.storage
  target                = var.target
  catalog               = var.catalog
  clusters              = var.clusters
  configuration         = var.configuration
  continuous            = var.continuous
  development           = var.development
  edition               = var.edition
  channel               = var.channel
  photon                = var.photon
  serverless            = var.serverless
  allow_duplicate_names = var.allow_duplicate_names
  libraries             = var.libraries
  notifications         = var.notifications
}

# Set permissions on the pipeline for the owner group
module "pipeline_permissions" {
  count  = var.owner_group_name != null ? 1 : 0
  source = "../../modules/permissions"

  pipeline_id = module.pipeline.id
  access_control_list = concat(
    var.owner_group_name != null ? [{
      group_name             = var.owner_group_name
      user_name              = null
      service_principal_name = null
      permission_level       = "CAN_MANAGE"
    }] : [],
    var.additional_access_control_list
  )
}
