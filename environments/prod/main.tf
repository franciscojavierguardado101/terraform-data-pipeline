data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

module "s3_landing" {
  source      = "../../modules/s3-landing"
  bucket_name = "francisco-guardado-${var.environment}-data-landing"
  environment = var.environment
}

module "rds" {
  source              = "../../modules/rds"
  environment         = var.environment
  vpc_id              = data.aws_vpc.default.id
  subnet_ids          = data.aws_subnets.default.ids
  allowed_cidr_blocks = [data.aws_vpc.default.cidr_block]
  db_name             = var.db_name
  db_username         = var.db_username
  db_password         = var.db_password
  instance_class      = "db.t3.micro"
  allocated_storage   = 20
  skip_final_snapshot = false  # always take a snapshot before destroying prod
}

module "iam" {
  source             = "../../modules/iam"
  environment        = var.environment
  landing_bucket_arn = module.s3_landing.bucket_arn
}

module "gcs_processed" {
  source        = "../../modules/gcs-processed"
  bucket_name   = "francisco-guardado-${var.environment}-data-processed"
  location      = "US"
  environment   = var.environment
  force_destroy = false  # never auto-delete prod data
}
