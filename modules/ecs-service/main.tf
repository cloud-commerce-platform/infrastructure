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
  launch_type     = "EC2"

  desired_count = var.desired_count

  deployment_minimum_healthy_percent = 0
  deployment_maximum_percent         = 100

  # Mala practica, pero estoy en Free tier :v
  force_new_deployment = true
  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = var.security_groups
    assign_public_ip = var.assign_public_ip
  }

  dynamic "load_balancer" {
    for_each = var.expose_via_alb ? [1] : []
    content {
      target_group_arn = var.target_group_arn
      container_name   = var.container_name
      container_port   = var.container_port
    }
  }

  health_check_grace_period_seconds = 100

  depends_on = [var.target_group_arn]

}

