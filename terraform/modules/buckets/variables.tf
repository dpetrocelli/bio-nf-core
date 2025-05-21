variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "credentials_file_path" {
  description = "Path to GCP service account credentials file"
}

variable "region" {
  description = "GCP Region"
  type        = string
  default     = "us-central1"
}

# variable "bucket_name" {
#   description = "Name of the GCS bucket"
#   type        = string
# }

# variable "environment" {
#   description = "Deployment environment label"
#   type        = string
#   default     = "dev"
# }

# variable "kms_key_name" {
#   description = "Optional KMS key for encryption"
#   type        = string
#   default     = null
# }
