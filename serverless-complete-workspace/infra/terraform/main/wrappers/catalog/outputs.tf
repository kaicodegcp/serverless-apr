output "id" {
  description = "The ID of the catalog"
  value       = module.catalog.id
}

output "name" {
  description = "The name of the catalog"
  value       = module.catalog.name
}

output "metastore_id" {
  description = "The ID of the metastore"
  value       = module.catalog.metastore_id
}
