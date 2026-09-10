# GCS bucket — receives the cleaned/processed data output from the pipeline
resource "google_storage_bucket" "processed" {
  name                        = var.bucket_name
  location                    = var.location
  force_destroy               = var.force_destroy
  uniform_bucket_level_access = true

  labels = {
    environment = var.environment
    purpose     = "processed-data"
  }
}
