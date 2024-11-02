variable "region" {
  default = "us-east-1"
}



# core VPC paramters 
variable "web_app_cidr" {
  default = "10.10.0.0/16"
}

# public subnets
variable "public_subnet_a_cidr" {
  default = "10.10.1.0/24"
}

variable "public_subnet_b_cidr" {
  default = "10.10.2.0/24"
}

variable "public_subnet_c_cidr" {
  default = "10.10.3.0/24"
}

# app subnets
variable "app_subnet_a_cidr" {
  default = "10.10.11.0/24"
}

variable "app_subnet_b_cidr" {
  default = "10.10.12.0/24"
}

variable "app_subnet_c_cidr" {
  default = "10.10.13.0/24"
}

# database subnets
variable "db_subnet_a_cidr" {
  default = "10.10.21.0/24"
}

variable "db_subnet_b_cidr" {
  default = "10.10.22.0/24"
}

variable "db_subnet_c_cidr" {
  default = "10.10.23.0/24"
}






# EC2 Parameters
variable "linux" {
  default = "ami-06b21ccaeff8cd686"
}

variable "key" {
  default = "tf-key-test"
}

