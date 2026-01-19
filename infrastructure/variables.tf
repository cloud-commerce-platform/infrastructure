variable "order_service_database_password" {
  type = string
  sensitive = true
}


variable "inventory_service_database_url" {
  type      = string
  sensitive = true
}

variable "private_subnets" {
  description = "Private subnet IDs where ECS services will run"
  type        = list(string)
}

variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-2"
}

