resource "aws_ecr_lifecycle_policy" "cleanup" {
  for_each = toset(local.ecr_repositories)

  repository = aws_ecr_repository.services[each.value].name

  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "Keep only last 1 images"
      selection = {
        tagStatus   = "any"
        countType   = "imageCountMoreThan"
        countNumber = 1
      }
      action = {
        type = "expire"
      }
    }]
  })
}

