# Public Route Table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id

  # Route for Internet traffic via Internet Gateway (IGW)
  route {
    cidr_block = "0.0.0.0/0"                 # All traffic to the Internet
    gateway_id = aws_internet_gateway.igw.id # Route to the IGW
  }

  tags = {
    Name = "public-route-table"
    env  = "dev"
  }
}

# Associate Public Subnets with Public Route Table
resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public-a.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.public-b.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_c" {
  subnet_id      = aws_subnet.public-c.id
  route_table_id = aws_route_table.public_route_table.id
}

# Private Application Route Table
resource "aws_route_table" "private_app_route_table" {
  vpc_id = aws_vpc.main.id

  # Route for outbound traffic via NAT Gateway
  route {
    cidr_block     = "0.0.0.0/0"                # All traffic to the Internet
    nat_gateway_id = aws_nat_gateway.app_nat.id # Route through NAT Gateway
  }

  tags = {
    Name = "private-app-route-table"
    env  = "dev"
  }
}

# Associate Application Subnets with Private App Route Table
resource "aws_route_table_association" "app_a" {
  subnet_id      = aws_subnet.private-app-a.id
  route_table_id = aws_route_table.private_app_route_table.id
}

resource "aws_route_table_association" "app_b" {
  subnet_id      = aws_subnet.private-app-b.id
  route_table_id = aws_route_table.private_app_route_table.id
}

resource "aws_route_table_association" "app_c" {
  subnet_id      = aws_subnet.private-app-c.id
  route_table_id = aws_route_table.private_app_route_table.id
}

# Private Database Route Table (Isolated, No Routes to Internet)
resource "aws_route_table" "private_db_route_table" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "private-db-route-table"
    env  = "dev"
  }
}

# Associate Database Subnets with Private DB Route Table
resource "aws_route_table_association" "db_a" {
  subnet_id      = aws_subnet.private-db-a.id
  route_table_id = aws_route_table.private_db_route_table.id
}

resource "aws_route_table_association" "db_b" {
  subnet_id      = aws_subnet.private-db-b.id
  route_table_id = aws_route_table.private_db_route_table.id
}

resource "aws_route_table_association" "db_c" {
  subnet_id      = aws_subnet.private-db-c.id
  route_table_id = aws_route_table.private_db_route_table.id
}
