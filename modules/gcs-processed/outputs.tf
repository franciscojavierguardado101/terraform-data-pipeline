output "bucket_name" {
  value = google_storage_bucket.processed.name
}

output "bucket_url" {
  value = google_storage_bucket.processed.url
}
