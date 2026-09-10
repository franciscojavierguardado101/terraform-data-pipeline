variable "bucket_name" {
  type        = string
  description = "GCS bucket name for processed data output"
}

variable "location" {
  type    = string
  default = "US"
}

variable "environment" {
  type = string
}

variable "force_destroy" {
  type    = bool
  default = false
}
