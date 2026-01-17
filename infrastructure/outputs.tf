# VPC & Network 
output "vpc_id" {
  value       = data.aws_vpc.default.id
  description = "The ID of the default VPC"
}

output "private_subnets" {
  value       = var.private_subnets
  description = "List of private subnet IDs"
}

# ECS Clusters 
output "services_cluster_id" {
  value       = module.services_cluster.cluster_id
  description = "ID of the services ECS cluster"
}

output "rabbitmq_cluster_id" {
  value       = module.rabbitmq_cluster.cluster_id
  description = "ID of the RabbitMQ ECS cluster"
}

# IAM Roles 
output "ecs_task_execution_role_arn" {
  value       = module.iam.ecs_task_execution_role_arn
  description = "Role ARN for ECS Task Execution"
}

output "order_service_task_role_arn" {
  value       = module.iam.order_service_task_role_arn
  description = "Role ARN for Order Service Task"
}

output "inventory_service_task_role_arn" {
  value       = module.iam.inventory_service_task_role_arn
  description = "Role ARN for Inventory Service Task"
}

# Security Groups 
output "order_service_sg_id" {
  value = module.security_group.order_service_sg_id
}

output "rabbitmq_sg_id" {
  value = module.security_group.rabbitmq_sg_id
}

output "common_sg_id" {
  value = module.security_group.common_sg_id
}

# Load Balancers 
output "order_service_tg_arn" {
  value = module.load_balancer.order_service_tg_arn
}

output "rabbitmq_tg_arn" {
  value = module.load_balancer.rabbitmq_tg_arn
}

output "rabbitmq_nlb_dns" {
  value = module.load_balancer.rabbitmq_nlb_dns
}

# ECR 
output "ecr_repository_urls" {
  value = { for k, v in aws_ecr_repository.services : k => v.repository_url }
}

# SSM Parameters (Secrets & Config) 
output "ssm_order_service_db_url_arn" {
  value = aws_ssm_parameter.order_service_db_url.arn
}

output "ssm_redis_host_arn" {
  value = aws_ssm_parameter.redis_host.arn
}

output "ssm_rabbitmq_username_arn" {
  value = aws_ssm_parameter.rabbitmq_username.arn
}

output "ssm_rabbitmq_password_arn" {
  value = aws_ssm_parameter.rabbitmq_password.arn
}

output "ssm_inventory_service_db_url_arn" {
  value = aws_ssm_parameter.inventory_service_db_url.arn
}


output "order_service_url" {
  description = "Full URL to access the Order Service"
  value       = "http://${module.load_balancer.order_service_alb_dns}"
}

output "rabbitmq_connection_info" {
  description = "Connection information for RabbitMQ"
  value = {
    nlb_dns            = module.load_balancer.rabbitmq_nlb_dns
    username_parameter = aws_ssm_parameter.rabbitmq_username.name
    password_parameter = aws_ssm_parameter.rabbitmq_password.name
    port               = 5672
    management_port    = 15672
  }
  sensitive = true
}

output "redis_endpoint" {
  description = "Redis endpoint information"
  value = {
    host     = aws_ssm_parameter.redis_host.value
    endpoint = module.data_store.redis_endpoint
  }
  sensitive = true
}
