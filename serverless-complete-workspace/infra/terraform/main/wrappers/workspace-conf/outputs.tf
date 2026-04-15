output "workspace_conf_id" {
  description = "ID of the workspace configuration"
  value       = module.workspace_conf.workspace_conf_id
}

output "applied_settings" {
  description = "Applied workspace security settings"
  value       = module.workspace_conf.applied_settings
}

output "legacy_access_disabled" {
  description = "Whether legacy access has been disabled"
  value       = module.workspace_conf.legacy_access_disabled
}

output "legacy_dbfs_disabled" {
  description = "Whether legacy DBFS has been disabled"
  value       = module.workspace_conf.legacy_dbfs_disabled
}
