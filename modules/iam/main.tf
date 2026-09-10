# IAM role for the data pipeline service — uses a role (not a user) so services can assume it
resource "aws_iam_role" "pipeline" {
  name        = "${var.environment}-data-pipeline-role"
  description = "Role assumed by the pipeline service to read raw data and write to RDS"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"  # swap for ec2 or glue depending on your pipeline service
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Environment = var.environment
  }
}

# Policy — least privilege: only read from landing bucket, describe RDS
resource "aws_iam_policy" "pipeline" {
  name        = "${var.environment}-data-pipeline-policy"
  description = "Least privilege access for the data pipeline"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "ReadLandingZone"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          var.landing_bucket_arn,
          "${var.landing_bucket_arn}/*"
        ]
      },
      {
        Sid    = "ConnectToRDS"
        Effect = "Allow"
        Action = [
          "rds:DescribeDBInstances",
          "rds-db:connect"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "pipeline" {
  role       = aws_iam_role.pipeline.name
  policy_arn = aws_iam_policy.pipeline.arn
}
