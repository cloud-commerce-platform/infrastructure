output "common_sg_id" {
  value = aws_security_group.common_services.id
}

output "order_service_sg_id" {
  value = aws_security_group.order_service.id
}

output "rabbitmq_sg_id" {
  value = aws_security_group.rabbitmq.id
}

output "redis_sg_id" {
  value = aws_security_group.redis.id
}

output "order_service_alb_id" {
  value = aws_security_group.order_service_alb.id
  
}
