# modules/gke/outputs.tf
output "cluster_name" {
  description = "Cluster name"
  value       = google_container_cluster.primary.name
}

output "cluster_endpoint" {
  description = "Cluster endpoint"
  value       = google_container_cluster.primary.endpoint
  sensitive   = true
}

output "cluster_ca_certificate" {
  description = "Cluster CA certificate"
  value       = google_container_cluster.primary.master_auth[0].cluster_ca_certificate
  sensitive   = true
}

output "cluster_location" {
  description = "Cluster location"
  value       = google_container_cluster.primary.location
}

output "cluster_id" {
  description = "Cluster ID"
  value       = google_container_cluster.primary.id
}

output "node_pool_names" {
  description = "List of node pool names"
  value       = [for np in google_container_node_pool.node_pools : np.name]
}