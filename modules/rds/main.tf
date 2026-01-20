resource "aws_db_subnet_group" "rds" {
  name        = "rds-subnet-group-${var.service_name}"
  description = "Subnet group for RDS PostgreSQL instances"
  subnet_ids  = var.subnet_ids
  tags = {
    Name = "rds-subnet-group-${var.service_name}"
  }
}

resource "aws_db_parameter_group" "rds" {
  name   = "rds-postgresql18-parameter-group-${var.service_name}"
  family = "postgres18"
  tags = {
    Name = "rds-postgresql18-parameter-group-${var.service_name}"
  }
}

# database instance
resource "aws_db_instance" "this" {
  identifier                   = var.rds_identifier
  engine                       = "postgres"
  engine_version               = "18.1"
  instance_class               = "db.t3.micro"
  allocated_storage            = 20
  storage_type                 = "gp2"
  storage_encrypted            = true
  kms_key_id                   = var.kms_key_id
  db_name                      = var.rds_db_name
  username                     = var.rds_db_username
  password                     = var.rds_db_password
  db_subnet_group_name         = aws_db_subnet_group.rds.name
  vpc_security_group_ids       = var.security_group_ids
  parameter_group_name         = aws_db_parameter_group.rds.name
  multi_az                     = false
  publicly_accessible          = false
  skip_final_snapshot          = true
  backup_retention_period      = 7
  backup_window                = "03:00-04:00"
  maintenance_window           = "Mon:04:00-Mon:05:00"
  performance_insights_enabled = false

  tags = {
    Name    = var.rds_identifier
    Service = var.service_name
  }
}
