# Reference the default VPC and subnets — avoids creating a full VPC for this project
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# S3 landing zone — raw data arrives here
module "s3_landing" {
  source      = "../../modules/s3-landing"
  bucket_name = "francisco-guardado-${var.environment}-data-landing"
  environment = var.environment
}

# PostgreSQL database — stores processed/structured data
module "rds" {
  source              = "../../modules/rds"
  environment         = var.environment
  vpc_id              = data.aws_vpc.default.id
  subnet_ids          = data.aws_subnets.default.ids
  allowed_cidr_blocks = [data.aws_vpc.default.cidr_block]
  db_name             = var.db_name
  db_username         = var.db_username
  db_password         = var.db_password
  instance_class      = "db.t3.micro"   # free tier eligible
  allocated_storage   = 20
  skip_final_snapshot = true            # ok for dev — always take snapshots in prod
}

# IAM role for the pipeline service to read from S3 and connect to RDS
module "iam" {
  source             = "../../modules/iam"
  environment        = var.environment
  landing_bucket_arn = module.s3_landing.bucket_arn
}

# GCS bucket on Google Cloud — processed data output destination
module "gcs_processed" {
  source        = "../../modules/gcs-processed"
  bucket_name   = "francisco-guardado-${var.environment}-data-processed"
  location      = "US"
  environment   = var.environment
  force_destroy = true
}
