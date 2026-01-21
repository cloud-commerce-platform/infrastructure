resource "aws_ecs_task_definition" "main" {
  family                   = var.task_family
  requires_compatibilities = ["EC2"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "256"

  execution_role_arn = var.execution_role_arn
  task_role_arn      = var.task_role_arn

  container_definitions = var.container_definitions
}

resource "aws_ecs_service" "this" {
  name            = var.service_name
  cluster         = var.cluster_id
  task_definition = aws_ecs_task_definition.main.arn

  desired_count = var.desired_count

  deployment_minimum_healthy_percent = 0
  deployment_maximum_percent         = 100

  # Mala practica, pero estoy en Free tier :v
  force_new_deployment = true
  triggers = {
    redeployment = timestamp()
  }

  network_configuration {
    subnets         = var.subnet_ids
    security_groups = var.security_groups
  }

  capacity_provider_strategy {
    capacity_provider = var.capacity_provider_name
    weight            = 1
    base              = 1
  }

  dynamic "load_balancer" {
    for_each = var.expose_via_alb ? [1] : []
    content {
      target_group_arn = var.target_group_arn
      container_name   = var.container_name
      container_port   = var.container_port
    }
  }

  dynamic "service_connect_configuration" {
    for_each = var.service_connect_enabled ? [1] : []
    content {
      enabled   = true
      namespace = var.service_connect_namespace

      dynamic "service" {
        for_each = var.service_connect_service_name != null ? [1] : []
        content {
          discovery_name = var.service_connect_service_name
          port_name      = var.service_connect_port_name

          dynamic "client_alias" {
            for_each = var.service_connect_client_alias != null ? [1] : []
            content {
              dns_name = var.service_connect_client_alias.dns_name
              port     = var.service_connect_client_alias.port
            }
          }
        }
      }
    }
  }

  health_check_grace_period_seconds = 300
}

