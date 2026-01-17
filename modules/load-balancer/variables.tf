variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs"
  type        = list(string)
}

variable "order_service_alb_id" {
  description = "ID for ALB order_service"
  type = list(string)
}

