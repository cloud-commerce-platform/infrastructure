variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "min_size" {
  description = "Minimum size of the ASG"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum size of the ASG"
  type        = number
  default     = 2
}

variable "desired_capacity" {
  description = "Desired capacity of the ASG"
  type        = number
  default     = 2
}

variable "subnet_ids" {
  description = "List of subnet IDs for the ASG"
  type        = list(string)
}

variable "ami_id" {
  description = "The AMI ID to use for the instances"
  type        = string
}

variable "instance_profile_name" {
  description = "The name of the IAM instance profile"
  type        = string
}

variable "target_group_arns" {
  description = "List of Target Group ARNs to attach to the ASG"
  type        = list(string)
  default     = []
}
