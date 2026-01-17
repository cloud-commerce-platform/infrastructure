resource "aws_cloudwatch_log_group" "order_service" {
  name              = "/ecs/order-service"
  retention_in_days = 3

  tags = {
    Environment = "dev"
    Service     = "order-service"
  }
}


resource "aws_cloudwatch_log_group" "rabbitmq" {
  name              = "/ecs/rabbitmq"
  retention_in_days = 3

  tags = {
    Environment = "dev"
    Service     = "rabbitmq"
  }

}

resource "aws_cloudwatch_log_group" "inventory_service" {
  name              = "/ecs/inventory-service"
  retention_in_days = 3

  tags = {
    Environment = "dev"
    Service     = "inventory-service"
  }
}
