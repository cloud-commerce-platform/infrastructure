resource "aws_cloudwatch_metric_alarm" "services_cpu_high" {
  alarm_name          = "services-cpu-utilization-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 70

  dimensions = {
    AutoScalingGroupName = module.services_cluster.asg_name
  }

  alarm_actions = [aws_autoscaling_policy.services_cpu_scale_out.arn]
  ok_actions    = [aws_autoscaling_policy.services_cpu_scale_in.arn]
}

resource "aws_cloudwatch_metric_alarm" "services_cpu_low" {
  alarm_name          = "services-cpu-utilization-low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 30

  dimensions = {
    AutoScalingGroupName = module.services_cluster.asg_name
  }

  alarm_actions = [aws_autoscaling_policy.services_cpu_scale_in.arn]
}

