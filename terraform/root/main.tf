# main.tf
terraform {
  required_version = ">= 1.0.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.0.0"
    }
  }
}

provider "google" {
  project     = var.project_id
  region      = var.region
  credentials = file(var.credentials_file_path)
}

module "gke" {
  source = "../modules/gke"

  project_id   = var.project_id
  cluster_name = var.cluster_name
  region       = var.region
  zones        = var.zones

  network           = "default"
  subnetwork        = "default"
  ip_range_pods     = null
  ip_range_services = null

  node_pools = var.node_pools

  cluster_autoscaling        = var.cluster_autoscaling
  enable_private_nodes       = var.enable_private_nodes
  master_authorized_networks = var.master_authorized_networks
  release_channel            = var.release_channel
}

