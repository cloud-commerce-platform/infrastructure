# Recibe peticiones de internet 
resource "aws_security_group" "order_service_alb" {
  name   = "order-service-alb-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "order-service-alb-sg"
  }
}

resource "aws_security_group" "common_services" {
  name        = "common-services-sg"
  description = "Security group shared by all services in the cluster"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "common-services-sg"
  }
}

# Para las tareas ECS (contenedores)
resource "aws_security_group" "order_service" {
  name        = "order-service-sg"
  description = "Security group for order-service ECS tasks"
  vpc_id      = var.vpc_id

  ingress {
    description     = "HTTP access to order-service from ALB"
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = [aws_security_group.order_service_alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "order-service-sg"
    Service = "order-service"
  }
}

resource "aws_security_group" "rabbitmq" {
  name        = "rabbitmq-sg"
  description = "Security group for rabbitmq ECS tasks"
  vpc_id      = var.vpc_id

  # Trafico desde servicios con common_services SG
  ingress {
    from_port       = 5672
    to_port         = 5672
    protocol        = "tcp"
    security_groups = [aws_security_group.common_services.id]
  }

  # ESTEEEE!!! 
  ingress {
    from_port   = 5672
    to_port     = 5672
    protocol    = "tcp"
    cidr_blocks = ["172.31.0.0/16"]
  }

  # Management UI (15672) - acceso interno desde VPC
  ingress {
    from_port   = 15672
    to_port     = 15672
    protocol    = "tcp"
    cidr_blocks = ["172.31.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "rabbitmq-sg"
    Service = "rabbitmq"
  }
}

resource "aws_security_group" "redis" {
  name        = "redis-sg"
  description = "Security group for Redis ECS tasks"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = [aws_security_group.common_services.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
