resource "aws_lb_target_group" "web_app" {
  name        = "web-app-tg"
  port        = 80     # Change to 443 if needed
  protocol    = "HTTP" # Change to "HTTPS" if needed
  vpc_id      = aws_vpc.main.id
  target_type = "instance" # Targets are EC2 instances

  health_check {
    protocol            = "HTTP"
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }

  tags = {
    Name = "web-app-tg"
    env  = "dev"
  }
}

# Attach the ASG to the ALB target group
resource "aws_autoscaling_attachment" "web_app_asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.web_app.id # tf registry says to use id here....
  lb_target_group_arn    = aws_lb_target_group.web_app.arn
}
