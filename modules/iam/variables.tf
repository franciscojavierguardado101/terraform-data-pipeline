variable "environment" {
  type = string
}

variable "landing_bucket_arn" {
  type        = string
  description = "ARN of the S3 landing zone bucket — scopes the read permission"
}
