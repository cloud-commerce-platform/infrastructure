output "endpoint" {
  description = "RDS endpoint"
  value       = try(aws_db_instance.this.endpoint, null)
}

output "port" {
  description = "RDS port"
  value       = try(aws_db_instance.this.port, null)
}

output "db_name" {
  description = "Database name"
  value       = var.rds_db_name
}

output "username" {
  description = "Database username"
  value       = var.rds_db_username
}

output "database_url" {
  description = "PostgreSQL connection string (with password)"
  value = var.rds_identifier != null ? format(
    "postgresql://%s:%s@%s:%s/%s",
    var.rds_db_username,
    var.rds_db_password,
    aws_db_instance.this.address,
    aws_db_instance.this.port,
    var.rds_db_name
  ) : null
}

output "arn" {
  description = "RDS ARN"
  value       = try(aws_db_instance.this.arn, null)
}
