output "id" {
  description = "The ID of the schema"
  value       = module.schema.id
}

output "name" {
  description = "The name of the schema"
  value       = module.schema.name
}

output "full_name" {
  description = "Full name (catalog.schema)"
  value       = module.schema.full_name
}
