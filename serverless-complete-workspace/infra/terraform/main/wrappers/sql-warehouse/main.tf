# Wrapper: sql-warehouse
# Creates a SQL Warehouse with owner group permissions

module "sql_warehouse" {
  source = "../../modules/sql-warehouse"

  name                      = var.name
  cluster_size              = var.cluster_size
  max_num_clusters          = var.max_num_clusters
  min_num_clusters          = var.min_num_clusters
  auto_stop_mins            = var.auto_stop_mins
  enable_photon             = var.enable_photon
  enable_serverless_compute = var.enable_serverless_compute
  spot_instance_policy      = var.spot_instance_policy
  warehouse_type            = var.warehouse_type
  channel                   = var.channel
  custom_tags               = var.custom_tags
}

# Set permissions on the SQL warehouse for the owner group
module "warehouse_permissions" {
  count  = var.owner_group_name != null ? 1 : 0
  source = "../../modules/permissions"

  sql_endpoint_id = module.sql_warehouse.id
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
