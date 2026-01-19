# VPC

module "vpc" {
  source = "../modules/vpc"
}

# AMI
data "aws_ssm_parameter" "ecs_ami" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2/recommended/image_id"
}

# IAM

module "iam" {
  source = "../modules/iam"
}

# SG

module "security_group" {
  source = "../modules/security-group"
  vpc_id = module.vpc.vpc_id
}

# LB

module "load_balancer" {
  source               = "../modules/load-balancer"
  vpc_id               = module.vpc.vpc_id
  subnet_ids           = var.private_subnets
  order_service_alb_id = [module.security_group.order_service_alb_id]

}

# Clusters

module "services_cluster" {
  source                = "../modules/ecs-cluster"
  cluster_name          = "services-cluster"
  instance_type         = "t3.micro"
  subnet_ids            = var.private_subnets
  ami_id                = data.aws_ssm_parameter.ecs_ami.value
  instance_profile_name = module.iam.ecs_instance_profile_name
}

module "rabbitmq_cluster" {
  source                = "../modules/ecs-cluster"
  cluster_name          = "rabbitmq-cluster"
  instance_type         = "t3.micro"
  subnet_ids            = var.private_subnets
  ami_id                = data.aws_ssm_parameter.ecs_ami.value
  instance_profile_name = module.iam.ecs_instance_profile_name
  target_group_arns     = [module.load_balancer.rabbitmq_tg_arn]
  desired_capacity      = 1
  max_size              = 1
}

# Data-Store
# Redis
module "data_store" {
  source             = "../modules/data-store"
  subnet_ids         = var.private_subnets
  security_group_ids = [module.security_group.redis_sg_id]
}

# RDS
module "order_service_rds" {
  source = "../modules/rds"

  subnet_ids         = var.private_subnets
  security_group_ids = [module.security_group.rds_sg_id]

  rds_identifier = "order-service-db"
  rds_db_name = "orders"
  rds_db_username = "orders_user"
  rds_db_password = var.order_service_database_password

  kms_key_id = data.aws_kms_key.containers.arn
  service_name = "order-service"
}


