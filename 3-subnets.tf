# public facing subnets 

resource "aws_subnet" "public-a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_a_cidr
  map_public_ip_on_launch = true # Assign public IPs to instances
  availability_zone       = "${var.region}a"
  tags = {
    Name = "public-a"
    env  = "dev"
  }
}

resource "aws_subnet" "public-b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_b_cidr
  map_public_ip_on_launch = true # Assign public IPs to instances
  availability_zone       = "${var.region}b"
  tags = {
    Name = "public-b"
    env  = "dev"
  }
}

resource "aws_subnet" "public-c" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_c_cidr
  map_public_ip_on_launch = true # Assign public IPs to instances
  availability_zone       = "${var.region}c"
  tags = {
    Name = "public-c"
    env  = "dev"
  }
}


# application subnets 

resource "aws_subnet" "private-app-a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.app_subnet_a_cidr
  availability_zone = "${var.region}a"
  tags = {
    Name = "app-a"
    env  = "dev"
  }
}

resource "aws_subnet" "private-app-b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.app_subnet_b_cidr
  availability_zone = "${var.region}b"
  tags = {
    Name = "app-b"
    env  = "dev"
  }
}

resource "aws_subnet" "private-app-c" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.app_subnet_c_cidr
  availability_zone = "${var.region}c"
  tags = {
    Name = "app-c"
    env  = "dev"
  }
}


# database subnets 

resource "aws_subnet" "private-db-a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.db_subnet_a_cidr
  availability_zone = "${var.region}a"
  tags = {
    Name = "db-a"
    env  = "dev"
  }
}

resource "aws_subnet" "private-db-b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.db_subnet_b_cidr
  availability_zone = "${var.region}b"
  tags = {
    Name = "db-b"
    env  = "dev"
  }
}

resource "aws_subnet" "private-db-c" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.db_subnet_c_cidr
  availability_zone = "${var.region}c"
  tags = {
    Name = "db-c"
    env  = "dev"
  }
}
