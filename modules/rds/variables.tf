variable "subnet_ids" {
  description = "List of subnet IDs"
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of security group IDs"
  type        = list(string)
}

variable "rds_identifier" {
  description = "Rds identifier"
  type        = string
}

variable "kms_key_id" {
  description = "Rds kms-key ID"
  type        = string
}

variable "rds_db_name" {
  description = "Database name to login"
  type        = string

}

variable "rds_db_username" {
  description = "Database username to login"
  type        = string

}

variable "rds_db_password" {
  description = "Database password to connect"
  type = string
}

variable "service_name" {
  description = "Service name for tag"
  type        = string
}


