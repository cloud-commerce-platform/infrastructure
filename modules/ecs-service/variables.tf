variable "service_name" {
  description = "Name of the service"
  type        = string
}

variable "cluster_id" {
  description = "ID of the ECS cluster"
  type        = string
}

variable "task_family" {
  description = "Family name of the task definition"
  type        = string
}

variable "container_definitions" {
  description = "JSON container definitions"
  type        = string
}

variable "execution_role_arn" {
  description = "ARN of the task execution role"
  type        = string
}

variable "task_role_arn" {
  description = "ARN of the task role (optional)"
  type        = string
  default     = null
}

variable "desired_count" {
  description = "Desired number of tasks"
  type        = number
  default     = 1
}

variable "subnet_ids" {
  description = "List of subnets for the service"
  type        = list(string)
}

variable "security_groups" {
  description = "List of security groups for the service"
  type        = list(string)
}

variable "assign_public_ip" {
  description = "Whether to assign a public IP"
  type        = bool
  default     = false
}

variable "expose_via_alb" {
  description = "Whether the service is exposed via ALB"
  type        = bool
  default     = false
}

variable "target_group_arn" {
  description = "Target group ARN (required if expose_via_alb = true)"
  type        = string
  default     = null
}

variable "container_name" {
  description = "Container name (required if expose_via_alb = true)"
  type        = string
  default     = null
}

variable "container_port" {
  description = "Container port (required if expose_via_alb = true)"
  type        = number
  default     = null
}

variable "capacity_provider_name" {
  type = string
}
