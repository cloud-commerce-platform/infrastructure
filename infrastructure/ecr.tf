locals {
  ecr_repositories = [
    "order-service", "rabbitmq", "inventory-service"
  ]
}

resource "aws_ecr_repository" "services" {
  for_each = toset(local.ecr_repositories)
  name     = each.value

  image_tag_mutability = "MUTABLE"

  encryption_configuration {
    encryption_type = "KMS"
    kms_key         = data.aws_kms_key.containers.arn
  }

  image_scanning_configuration {
    scan_on_push = true
  }

  force_delete = true
}
