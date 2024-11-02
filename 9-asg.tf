resource "aws_autoscaling_group" "web_app" {
  desired_capacity = 4  # Number of instances to maintain
  min_size         = 3  # Minimum number of instances
  max_size         = 7 # Maximum number of instances
  vpc_zone_identifier = [
    aws_subnet.private-app-a.id,
    aws_subnet.private-app-b.id,
    aws_subnet.private-app-c.id
  ]

  launch_template {
    id      = aws_launch_template.web_app.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.web_app.arn]

  health_check_type         = "ELB" # Use "ELB" for ALB health checks
  health_check_grace_period = 300   # Wait 5 minutes for the instance to boot

  tag {
    key                 = "Name"
    value               = "web-app-group"
    propagate_at_launch = true
  }

  tag {
    key                 = "env"
    value               = "dev"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true # Ensure new ASG is ready before replacing old one
  }
}

# Target Tracking Scaling Policy
resource "aws_autoscaling_policy" "cpu_utilization_scaling" {
  name                      = "cpu-utilization-scaling"
  autoscaling_group_name    = aws_autoscaling_group.web_app.name
  policy_type               = "TargetTrackingScaling"
  estimated_instance_warmup = 30 # Time to wait after a scaling activity before the next one

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization" # Metric to track
    }
    target_value = 75.0 # Desired CPU utilization percentage
  }
}

