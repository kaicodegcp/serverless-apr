output "id" {
  description = "The ID of the storage configuration"
  value       = module.mws_storage_configuration.id
}

output "storage_configuration_id" {
  description = "The storage configuration ID"
  value       = module.mws_storage_configuration.storage_configuration_id
}

output "storage_configuration_name" {
  description = "The name of the storage configuration"
  value       = module.mws_storage_configuration.storage_configuration_name
}
