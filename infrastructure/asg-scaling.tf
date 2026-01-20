resource "aws_autoscaling_policy" "services_cpu_scale_out" {
  name                   = "services-cpu-scale-out"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  policy_type            = "SimpleScaling"
  autoscaling_group_name = module.services_cluster.asg_name
}

resource "aws_autoscaling_policy" "services_cpu_scale_in" {
  name                   = "services-cpu-scale-in"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  policy_type            = "SimpleScaling"
  autoscaling_group_name = module.services_cluster.asg_name
}

