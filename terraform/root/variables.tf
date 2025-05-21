# variables.tf
variable "project_id" {
  description = "The project ID to host the cluster in"
  type        = string
}

variable "cluster_name" {
  description = "The name of the cluster"
  type        = string
  default     = "my-gke-cluster"
}

variable "region" {
  description = "The region to host the cluster in"
  type        = string
  default     = "us-central1"
}

variable "zones" {
  description = "The zones to host the cluster in"
  type        = list(string)
  default     = ["us-central1-a", "us-central1-b"]
}

variable "network" {
  description = "The VPC network to host the cluster in"
  type        = string
  default     = "default"
}

variable "subnetwork" {
  description = "The subnetwork to host the cluster in"
  type        = string
  default     = "default"
}

variable "ip_range_pods" {
  description = "The secondary ip range to use for pods"
  type        = string
  default     = "pods"
}

variable "ip_range_services" {
  description = "The secondary ip range to use for services"
  type        = string
  default     = "services"
}

variable "node_pools" {
  description = "List of node pools to create"
  type = list(object({
    name               = string
    machine_type       = string
    node_locations     = string
    min_count          = number
    max_count          = number
    disk_size_gb       = number
    disk_type          = string
    image_type         = string
    auto_repair        = bool
    auto_upgrade       = bool
    preemptible        = bool
    initial_node_count = number
  }))
  default = [
    {
      name               = "default-node-pool"
      machine_type       = "e2-medium"
      node_locations     = "us-central1-a,us-central1-b"
      min_count          = 1
      max_count          = 3
      disk_size_gb       = 20
      disk_type          = "pd-standard"
      image_type         = "COS_CONTAINERD"
      auto_repair        = true
      auto_upgrade       = true
      preemptible        = true
      initial_node_count = 1
    }
  ]
}

variable "cluster_autoscaling" {
  description = "Configuration for cluster autoscaling"
  type = object({
    enabled    = bool
    cpu_min    = number
    cpu_max    = number
    memory_min = number
    memory_max = number
  })
  default = {
    enabled    = false
    cpu_min    = 0
    cpu_max    = 0
    memory_min = 0
    memory_max = 0
  }
}

variable "enable_private_nodes" {
  description = "Whether to create a private cluster"
  type        = bool
  default     = true
}

variable "master_authorized_networks" {
  description = "List of master authorized networks"
  type = list(object({
    cidr_block   = string
    display_name = string
  }))
  default = [
    {
      cidr_block   = "0.0.0.0/0"
      display_name = "all-for-testing"
    }
  ]
}

variable "release_channel" {
  description = "The release channel of the cluster"
  type        = string
  default     = "REGULAR"
}

variable "credentials_file_path" {
  description = "Path to GCP service account credentials file"
  default     = "../../credentials/grupo2.json"
}
