resource "aws_ssm_parameter" "order_service_db_url" {
  name  = "/microservices/order-service/database-url"
  type  = "SecureString"
  value = var.order_service_database_url
}

resource "aws_ssm_parameter" "redis_host" {
  name  = "/microservices/redis/host"
  type  = "String"
  value = module.data_store.redis_endpoint
}

resource "aws_ssm_parameter" "rabbitmq_username" {
  name        = "/microservices/rabbitmq/username"
  type        = "SecureString"
  value       = "guest"
  description = "Username for RabbitMQ"
  tags = {
    Service = "rabbitmq"
  }
}

resource "aws_ssm_parameter" "rabbitmq_password" {
  name        = "/microservices/rabbitmq/password"
  type        = "SecureString"
  value       = "guest"
  description = "Password for RabbitMQ"
  tags = {
    Service = "rabbitmq"
  }
}

resource "aws_ssm_parameter" "inventory_service_db_url" {
  name  = "/microservices/inventory-service/database-url"
  type  = "SecureString"
  value = var.inventory_service_database_url

}
