
resource "aws_vpc" "main" {
  cidr_block           = var.web_app_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "web_app"
    env  = "dev"
  }
}