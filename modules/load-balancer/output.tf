output "order_service_tg_arn" {
  value = aws_lb_target_group.order_service.arn
}

output "order_service_alb" {
  value = aws_lb.order_service
}

output "order_service_alb_dns" {
  value = aws_lb.order_service.dns_name
}
