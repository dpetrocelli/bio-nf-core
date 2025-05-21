resource "google_service_account" "kubernetes" {
  account_id   = "kubernetes"
  display_name = "Kubernetes Node Service Account"
}

resource "google_container_node_pool" "general" {
  name    = "general"
  cluster = google_container_cluster.primary.id

  node_count = 1

  node_config {
    machine_type    = "e2-micro" # ✅ Ultra low consumption
    disk_size_gb    = 10
    preemptible     = false
    service_account = google_service_account.kubernetes.email

    oauth_scopes = ["https://www.googleapis.com/auth/cloud-platform"]

    workload_metadata_config {
      mode = "GKE_METADATA"
    }
  }
}

resource "google_container_node_pool" "spot" {
  name    = "spot"
  cluster = google_container_cluster.primary.id

  node_count = 1

  node_config {
    machine_type    = "e2-micro"
    disk_size_gb    = 10
    preemptible     = true
    service_account = google_service_account.kubernetes.email

    oauth_scopes = ["https://www.googleapis.com/auth/cloud-platform"]

    workload_metadata_config {
      mode = "GKE_METADATA"
    }
  }
}
