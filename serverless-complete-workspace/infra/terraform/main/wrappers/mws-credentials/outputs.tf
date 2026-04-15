output "id" {
  description = "The ID of the credentials configuration"
  value       = module.mws_credentials.id
}

output "credentials_id" {
  description = "The credentials ID"
  value       = module.mws_credentials.credentials_id
}

output "credentials_name" {
  description = "The name of the credentials"
  value       = module.mws_credentials.credentials_name
}

output "external_id" {
  description = "The external ID for the trust relationship"
  value       = module.mws_credentials.external_id
}
