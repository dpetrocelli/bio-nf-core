# provider "google" {
#   project     = var.project_id
#   region      = var.region
#   credentials = file(var.credentials_file_path)
# }

# resource "google_storage_bucket" "nextflow_work" {
#   name          = var.bucket_name
#   location      = var.region
#   force_destroy = true # WARNING: Allows deleting non-empty buckets

#   uniform_bucket_level_access = true

#   versioning {
#     enabled = true
#   }

#   lifecycle_rule {
#     action {
#       type = "Delete"
#     }
#     condition {
#       age = 30 # Auto-delete objects older than 30 days (adjust as needed)
#     }
#   }

#   dynamic "encryption" {
#     for_each = var.kms_key_name != null && var.kms_key_name != "" ? [1] : []
#     content {
#       default_kms_key_name = var.kms_key_name
#     }
#   }

#   labels = {
#     environment = var.environment
#     owner       = "nextflow"
#   }
# }

# output "bucket_name" {
#   value = google_storage_bucket.nextflow_work.name
# }

# Create new storage bucket in the US multi-region
# with coldline storage

provider "google" {
  project     = var.project_id
  region      = var.region
  credentials = file(var.credentials_file_path)
}
resource "random_id" "bucket_prefix" {
  byte_length = 8
}

resource "google_storage_bucket" "static" {
  name          = "${random_id.bucket_prefix.hex}-new-bucket"
  location      = "US"
  storage_class = "COLDLINE"

  uniform_bucket_level_access = true
}
