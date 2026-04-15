output "id" {
  description = "The ID of the table"
  value       = module.table.id
}

output "name" {
  description = "The name of the table"
  value       = module.table.name
}

output "full_name" {
  description = "Full name (catalog.schema.table)"
  value       = module.table.full_name
}
