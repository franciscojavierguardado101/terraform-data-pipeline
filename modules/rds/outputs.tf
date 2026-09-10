output "db_endpoint" {
  value       = aws_db_instance.postgres.endpoint
  description = "Connection endpoint for the database"
}

output "db_name" {
  value = aws_db_instance.postgres.db_name
}

output "db_port" {
  value = aws_db_instance.postgres.port
}
