output "cluster_id" {
  value = aws_ecs_cluster.main.id
}

output "cluster_name" {
  value = aws_ecs_cluster.main.name
}

output "asg_name" {
  value = aws_autoscaling_group.main.name
}
