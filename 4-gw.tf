# Internet Gateway Creation
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "my-internet-gateway"
    env  = "dev"
  }
}

# Elastic IP for NAT Gateway
resource "aws_eip" "nat_eip" {

  tags = {
    Name = "nat-eip"
    env  = "dev"
  }
}

# NAT Gateway in Availability Zone us-east-1a
resource "aws_nat_gateway" "app_nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public-a.id # Place NAT Gateway in Public Subnet A
  tags = {
    Name = "nat-gateway"
    env  = "dev"
  }
}
