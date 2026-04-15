# Wrapper: notebook
# Creates a notebook with owner group permissions

module "notebook" {
  source = "../../modules/notebook"

  path            = var.path
  language        = var.language
  format          = var.format
  content_base64  = var.content_base64
  notebook_source = var.notebook_source
}

# Set permissions on the notebook for the owner group
module "notebook_permissions" {
  count  = var.owner_group_name != null ? 1 : 0
  source = "../../modules/permissions"

  notebook_path = var.path
  access_control_list = concat(
    var.owner_group_name != null ? [{
      group_name             = var.owner_group_name
      user_name              = null
      service_principal_name = null
      permission_level       = "CAN_MANAGE"
    }] : [],
    var.additional_access_control_list
  )

  depends_on = [module.notebook]
}
