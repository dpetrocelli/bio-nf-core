# modules/gke/variables.tf
variable "project_id" {
  description = "The project ID to host the cluster in"
  type        = string
}

variable "cluster_name" {
  description = "The name of the cluster"
  type        = string
}

variable "region" {
  description = "The region to host the cluster in"
  type        = string
}

variable "zones" {
  description = "The zones to host the cluster in"
  type        = list(string)
  default     = []
}

variable "network" {
  description = "The VPC network to host the cluster in"
  type        = string
}

variable "subnetwork" {
  description = "The subnetwork to host the cluster in"
  type        = string
}

variable "ip_range_pods" {
  description = "The secondary ip range to use for pods"
  type        = string
}

variable "ip_range_services" {
  description = "The secondary ip range to use for services"
  type        = string
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
  default = []
}

variable "release_channel" {
  description = "The release channel of the cluster"
  type        = string
  default     = "REGULAR"
}

variable "enable_vertical_pod_autoscaling" {
  description = "Whether to enable vertical pod autoscaling"
  type        = bool
  default     = false
}

variable "enable_horizontal_pod_autoscaling" {
  description = "Whether to enable horizontal pod autoscaling"
  type        = bool
  default     = true
}

variable "enable_http_load_balancing" {
  description = "Whether to enable HTTP load balancing addon"
  type        = bool
  default     = true
}

variable "enable_network_policy" {
  description = "Whether to enable network policy addon"
  type        = bool
  default     = true
}

variable "maintenance_start_time" {
  description = "Time window specified for daily maintenance operations in RFC3339 format"
  type        = string
  default     = "05:00"
}

variable "remove_default_node_pool" {
  description = "Whether to remove the default node pool"
  type        = bool
  default     = true
}