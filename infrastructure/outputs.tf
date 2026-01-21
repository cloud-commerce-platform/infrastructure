# VPC & Network 
output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "The ID of the default VPC"
}

output "private_subnets" {
  value       = var.private_subnets
  description = "List of private subnet IDs"
}

# Service Discovery for Service Connect
output "service_discovery_namespace_arn" {
  description = "ARN of the Cloud Map namespace for Service Connect"
  value       = aws_service_discovery_private_dns_namespace.main.arn
}

output "service_discovery_namespace_id" {
  description = "ID of the Cloud Map namespace for Service Connect"
  value       = aws_service_discovery_private_dns_namespace.main.id
}

output "service_discovery_namespace_name" {
  description = "DNS name of the Cloud Map namespace (commerce-platform.local)"
  value       = aws_service_discovery_private_dns_namespace.main.name
}

output "rabbitmq_service_discovery_dns" {
  description = "DNS name for RabbitMQ via Service Connect"
  value       = "rabbitmq.${aws_service_discovery_private_dns_namespace.main.name}"
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

output "rabbitmq_capacity_provider_name" {
  value       = module.rabbitmq_cluster.capacity_provider_name
  description = "Capacity provider name for RabbitMQ cluster"
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

# NLB resources - DEPRECATED: Using Service Connect instead
# output "rabbitmq_tg_arn" {
#   value = module.load_balancer.rabbitmq_tg_arn
# }
# output "rabbitmq_nlb_dns" {
#   value = module.load_balancer.rabbitmq_nlb_dns
# }

output "capacity_provider_name" {
  value = module.services_cluster.capacity_provider_name
}

# ECR 
output "ecr_repository_urls" {
  value = { for k, v in aws_ecr_repository.services : k => v.repository_url }
}

# SSM Parameters (Secrets & Config) 
output "ssm_order_service_db_url_arn" {
  value = aws_ssm_parameter.order_service_db_url.arn
}

output "ssm_inventory_service_db_url_arn" {
  value = aws_ssm_parameter.inventory_service_db_url.arn
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

output "order_service_url" {
  description = "Full URL to access the Order Service"
  value       = "http://${module.load_balancer.order_service_alb_dns}"
}

output "rabbitmq_connection_info" {
  description = "Connection information for RabbitMQ via Service Connect"
  value = {
    service_discovery_dns = "rabbitmq.${aws_service_discovery_private_dns_namespace.main.name}"
    port                  = 5672
    management_port       = 15672
    username_parameter    = aws_ssm_parameter.rabbitmq_username.name
    password_parameter    = aws_ssm_parameter.rabbitmq_password.name
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
