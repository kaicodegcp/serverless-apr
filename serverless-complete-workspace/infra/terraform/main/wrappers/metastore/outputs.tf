output "id" {
  description = "The ID of the metastore"
  value       = module.metastore.id
}

output "metastore_id" {
  description = "The metastore ID"
  value       = module.metastore.metastore_id
}

output "name" {
  description = "The name of the metastore"
  value       = module.metastore.name
}

output "storage_root" {
  description = "The storage root of the metastore"
  value       = module.metastore.storage_root
}
