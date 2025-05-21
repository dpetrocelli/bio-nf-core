project_id   = "sd-hit3"
cluster_name = "my-gke-cluster"
region       = "us-central1"
node_pools = [
  {
    name               = "general"
    machine_type       = "e2-medium"
    min_count          = 1
    max_count          = 3
    preemptible        = false
    disk_size_gb       = 20
    disk_type          = "pd-standard"
    image_type         = "COS_CONTAINERD"
    initial_node_count = 1
    node_locations     = "us-central1-a,us-central1-b"
    auto_repair        = true
    auto_upgrade       = true
  },
  {
    name               = "spot"
    machine_type       = "e2-medium"
    min_count          = 1
    max_count          = 5
    preemptible        = true
    disk_size_gb       = 20
    disk_type          = "pd-standard"
    image_type         = "COS_CONTAINERD"
    initial_node_count = 1
    node_locations     = "us-central1-a,us-central1-b"
    auto_repair        = true
    auto_upgrade       = true
  }
]


