variable "bucket_name" {
  type        = string
  description = "Name of the S3 landing zone bucket"
}

variable "environment" {
  type        = string
  description = "Environment name (dev, staging, prod)"
}
