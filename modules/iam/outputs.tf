output "ecs_instance_profile_name" {
  value = aws_iam_instance_profile.ecs_instance_profile.name
}

output "ecs_task_execution_role_arn" {
  value = aws_iam_role.ecs_task_execution_role.arn
}

output "order_service_task_role_arn" {
  value = aws_iam_role.order_service_task_role.arn
}

output "inventory_service_task_role_arn" {
  value = aws_iam_role.inventory_service_task_role.arn
}
