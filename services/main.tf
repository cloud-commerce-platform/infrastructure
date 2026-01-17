locals {
  infra = data.terraform_remote_state.infra.outputs
}

module "rabbitmq_service" {
  source             = "../modules/ecs-service"
  service_name       = "rabbitmq"
  cluster_id         = local.infra.rabbitmq_cluster_id
  task_family        = "rabbitmq"
  execution_role_arn = local.infra.ecs_task_execution_role_arn
  subnet_ids         = local.infra.private_subnets
  security_groups    = [local.infra.rabbitmq_sg_id]
  assign_public_ip   = false

  expose_via_alb   = true
  target_group_arn = local.infra.rabbitmq_tg_arn
  container_name   = "rabbitmq"
  container_port   = 5672

  container_definitions = jsonencode([
    {
      name  = "rabbitmq"
      image = "${local.infra.ecr_repository_urls["rabbitmq"]}:3-management-alpine"

      portMappings = [
        {
          containerPort = 5672
          protocol      = "tcp"
        },
        {
          containerPort = 15672
          protocol      = "tcp"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.rabbitmq.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

module "order_service" {
  source             = "../modules/ecs-service"
  service_name       = "order-service"
  cluster_id         = local.infra.services_cluster_id
  task_family        = "order-service"
  execution_role_arn = local.infra.ecs_task_execution_role_arn
  task_role_arn      = local.infra.order_service_task_role_arn
  subnet_ids         = local.infra.private_subnets
  security_groups = [
    local.infra.order_service_sg_id,
    local.infra.common_sg_id
  ]

  expose_via_alb   = true
  target_group_arn = local.infra.order_service_tg_arn
  container_name   = "order-service"
  container_port   = 3000

  container_definitions = jsonencode([
    {
      name      = "order-service"
      image     = "${local.infra.ecr_repository_urls["order-service"]}:latest"
      essential = true

      secrets = [
        {
          name      = "DATABASE_URL"
          valueFrom = local.infra.ssm_order_service_db_url_arn
        },
        {
          name      = "REDIS_HOST"
          valueFrom = local.infra.ssm_redis_host_arn
        },
        {
          name      = "RABBITMQ_USERNAME"
          valueFrom = local.infra.ssm_rabbitmq_username_arn
        },
        {
          name      = "RABBITMQ_PASSWORD"
          valueFrom = local.infra.ssm_rabbitmq_password_arn
        }
      ]

      environment = [
        {
          name  = "RABBITMQ_HOST"
          value = local.infra.rabbitmq_nlb_dns
        },
        {
          name  = "NODE_ENV"
          value = "production"
        }
      ]

      portMappings = [
        {
          containerPort = 3000
          protocol      = "tcp"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.order_service.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

module "inventory_service" {
  source             = "../modules/ecs-service"
  service_name       = "inventory-service"
  cluster_id         = local.infra.services_cluster_id
  task_family        = "inventory-service"
  execution_role_arn = local.infra.ecs_task_execution_role_arn
  task_role_arn      = local.infra.inventory_service_task_role_arn
  subnet_ids         = local.infra.private_subnets
  security_groups    = [local.infra.common_sg_id]

  container_definitions = jsonencode([
    {
      name      = "inventory-service"
      image     = "${local.infra.ecr_repository_urls["inventory-service"]}:latest"
      essential = true

      secrets = [
        {
          name      = "DATABASE_URL"
          valueFrom = local.infra.ssm_inventory_service_db_url_arn
        },
        {
          name      = "RABBITMQ_USERNAME"
          valueFrom = local.infra.ssm_rabbitmq_username_arn
        },
        {
          name      = "RABBITMQ_PASSWORD"
          valueFrom = local.infra.ssm_rabbitmq_password_arn
        }
      ]

      environment = [
        {
          name  = "RABBITMQ_HOST"
          value = local.infra.rabbitmq_nlb_dns
        },
        {
          name  = "NODE_ENV"
          value = "production"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.inventory_service.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}
