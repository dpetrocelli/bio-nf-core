# outputs.tf
output "cluster_name" {
  description = "GKE Cluster Name"
  value       = module.gke.cluster_name
}

output "cluster_endpoint" {
  description = "GKE Cluster Endpoint"
  value       = module.gke.cluster_endpoint
  sensitive   = true
}

output "cluster_location" {
  description = "GKE Cluster Location"
  value       = module.gke.cluster_location
}

output "node_pool_names" {
  description = "List of node pool names"
  value       = module.gke.node_pool_names
}