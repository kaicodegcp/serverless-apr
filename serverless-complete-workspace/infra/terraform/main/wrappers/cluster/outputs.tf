output "id" {
  description = "The ID of the cluster"
  value       = module.cluster.id
}

output "cluster_id" {
  description = "The cluster ID"
  value       = module.cluster.cluster_id
}

output "cluster_name" {
  description = "The name of the cluster"
  value       = module.cluster.cluster_name
}

output "state" {
  description = "The current state of the cluster"
  value       = module.cluster.state
}

output "url" {
  description = "URL of the cluster"
  value       = module.cluster.url
}
