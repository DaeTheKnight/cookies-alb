# Create the Application Load Balancer
resource "aws_lb" "web_app" {
  name               = "web-app-alb"
  internal           = false # Set to true if the ALB is not public facing
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id] # Reference ALB security group
  subnets = [
    aws_subnet.public-a.id,
    aws_subnet.public-b.id,
    aws_subnet.public-c.id
  ]

  enable_deletion_protection = false # Set to true if you want to protect against accidental deletion

  tags = {
    Name = "web-app-alb"
    env  = "dev"
  }
}

# Create a listener for the ALB (HTTP only)
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.web_app.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_app.arn # Reference your existing target group
  }
}
