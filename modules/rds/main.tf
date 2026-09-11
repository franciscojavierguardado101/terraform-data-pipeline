# Security group — controls who can connect to the database
resource "aws_security_group" "rds" {
  name        = "${var.environment}-rds-sg"
  description = "Security group for RDS PostgreSQL - only allows inbound on port 5432"
  vpc_id      = var.vpc_id

  ingress {
    description = "PostgreSQL port"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Environment = var.environment
  }
}

# Subnet group — tells RDS which subnets it can run in
resource "aws_db_subnet_group" "rds" {
  name       = "${var.environment}-rds-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Environment = var.environment
  }
}

# PostgreSQL database instance
resource "aws_db_instance" "postgres" {
  identifier        = "${var.environment}-postgres"
  engine            = "postgres"
  engine_version    = "16"
  instance_class    = var.instance_class
  allocated_storage = var.allocated_storage

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.rds.name
  vpc_security_group_ids = [aws_security_group.rds.id]

  publicly_accessible = false   # never expose the database to the internet
  skip_final_snapshot = var.skip_final_snapshot

  tags = {
    Environment = var.environment
  }
}
