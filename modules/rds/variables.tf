variable "environment" {
  type = string
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where RDS will be deployed"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs for the RDS subnet group"
}

variable "allowed_cidr_blocks" {
  type        = list(string)
  description = "CIDR blocks allowed to connect to the database"
}

variable "instance_class" {
  type        = string
  description = "RDS instance type"
  default     = "db.t3.micro"  # free tier eligible
}

variable "allocated_storage" {
  type        = number
  description = "Storage size in GB"
  default     = 20  # free tier minimum
}

variable "db_name" {
  type        = string
  description = "Name of the initial database"
}

variable "db_username" {
  type        = string
  description = "Master username for the database"
}

variable "db_password" {
  type        = string
  sensitive   = true  # hides this value from logs and plan output
  description = "Master password — set via TF_VAR_db_password environment variable, never in tfvars"
}

variable "skip_final_snapshot" {
  type        = bool
  description = "Skip final snapshot on destroy — true for dev/staging, false for prod"
  default     = true
}
