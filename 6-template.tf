resource "aws_launch_template" "web_app" {
  name_prefix   = "web_app"
  image_id      = var.linux
  instance_type = "t2.micro"

  key_name = var.key

  vpc_security_group_ids = [aws_security_group.backend.id]

   # Use the templatefile function with base64encode for user_data
  user_data = base64encode(templatefile("./scripts/cookie/setup.sh.tpl", {
    app_content = local.app_content,
    systemctl   = local.systemctl
  }))

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "web-app-LT"
      env  = "dev"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}



locals {
  app_content = file("./scripts/cookie/app.py")
  systemctl   = file("./scripts/cookie/systemd.service")
}
