# modules/gke/main.tf
resource "google_container_cluster" "primary" {
  name           = var.cluster_name
  location       = var.region
  node_locations = length(var.zones) > 0 ? var.zones : null

  remove_default_node_pool = var.remove_default_node_pool
  initial_node_count       = 1
  network                  = var.network
  subnetwork               = var.subnetwork
  min_master_version       = "latest"
  deletion_protection      = false
  # IP allocation configuration
  ip_allocation_policy {
    cluster_secondary_range_name  = var.ip_range_pods
    services_secondary_range_name = var.ip_range_services
  }

  # Private cluster configuration
  private_cluster_config {
    enable_private_nodes    = var.enable_private_nodes
    enable_private_endpoint = false
    master_ipv4_cidr_block  = "172.16.0.0/28"
  }

  # Master authorized networks
  dynamic "master_authorized_networks_config" {
    for_each = length(var.master_authorized_networks) > 0 ? [1] : []
    content {
      dynamic "cidr_blocks" {
        for_each = var.master_authorized_networks
        iterator = network
        content {
          cidr_block   = network.value.cidr_block
          display_name = network.value.display_name
        }
      }
    }
  }

  # Release channel
  release_channel {
    channel = var.release_channel
  }

  # Cluster autoscaling
  dynamic "cluster_autoscaling" {
    for_each = var.cluster_autoscaling.enabled ? [1] : []
    content {
      enabled = true
      resource_limits {
        resource_type = "cpu"
        minimum       = var.cluster_autoscaling.cpu_min
        maximum       = var.cluster_autoscaling.cpu_max
      }
      resource_limits {
        resource_type = "memory"
        minimum       = var.cluster_autoscaling.memory_min
        maximum       = var.cluster_autoscaling.memory_max
      }
    }
  }

  # Addons
  addons_config {
    http_load_balancing {
      disabled = !var.enable_http_load_balancing
    }
    horizontal_pod_autoscaling {
      disabled = !var.enable_horizontal_pod_autoscaling
    }
    network_policy_config {
      disabled = !var.enable_network_policy
    }
  }

  # Vertical pod autoscaling
  vertical_pod_autoscaling {
    enabled = var.enable_vertical_pod_autoscaling
  }

  # Maintenance window
  maintenance_policy {
    daily_maintenance_window {
      start_time = var.maintenance_start_time
    }
  }

  # Workload identity
  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }
}

# Node pools
resource "google_container_node_pool" "node_pools" {
  for_each = { for np in var.node_pools : np.name => np }

  name           = each.value.name
  location       = var.region
  node_locations = each.value.node_locations != "" ? split(",", each.value.node_locations) : null


  cluster            = google_container_cluster.primary.name
  initial_node_count = each.value.initial_node_count

  autoscaling {
    min_node_count = each.value.min_count
    max_node_count = each.value.max_count
  }

  management {
    auto_repair  = each.value.auto_repair
    auto_upgrade = each.value.auto_upgrade
  }

  node_config {
    machine_type = each.value.machine_type
    disk_size_gb = each.value.disk_size_gb
    disk_type    = each.value.disk_type
    image_type   = each.value.image_type
    preemptible  = each.value.preemptible

    # Workload identity
    workload_metadata_config {
      mode = "GKE_METADATA"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}
