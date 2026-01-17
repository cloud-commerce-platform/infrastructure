# Network Load Balancer 
resource "aws_lb" "rabbitmq" {
  name                             = "rabbitmq-nlb"
  internal                         = true
  load_balancer_type               = "network"
  subnets                          = var.subnet_ids
  enable_cross_zone_load_balancing = true

  tags = {
    Service = "rabbitmq"
  }
}

resource "aws_lb_listener" "rabbitmq" {
  load_balancer_arn = aws_lb.rabbitmq.arn
  port              = 5672
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.rabbitmq.arn
  }
}

resource "aws_lb_target_group" "rabbitmq" {
  name        = "rabbitmq-tg"
  port        = 5672
  protocol    = "TCP"
  vpc_id      = var.vpc_id
  target_type = "ip"
}

# (OrderService)
resource "aws_lb" "order_service" {
  name               = "order-service-alb"
  internal           = false
  load_balancer_type = "application"

  subnets         = var.subnet_ids
  security_groups = var.order_service_alb_id

  tags = {
    Service = "order-service"
  }
}

resource "aws_lb_listener" "order_service" {
  load_balancer_arn = aws_lb.order_service.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.order_service.arn
  }
}

resource "aws_lb_target_group" "order_service" {
  name        = "order-service-tg"
  port        = 3000
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    enabled             = true
    path                = "/orders"
    port                = "traffic-port"
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 5
    timeout             = 10
    interval            = 30
    matcher             = "200-499" # rango aceptable
  }
}
