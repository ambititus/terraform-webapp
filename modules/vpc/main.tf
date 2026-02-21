

resource "aws_vpc" "terraform-project" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "webapp-vpc"
  }
}


resource "aws_internet_gateway" "webapp" {
  vpc_id = aws_vpc.terraform-project.id

  tags = {
    Name = "webapp-igw"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.terraform-project.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zone

  tags = {
    Name = "example-public-subnet"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.terraform-project.id

  route {
    cidr_block = var.route_cidr_block
    gateway_id = aws_internet_gateway.webapp.id
  }

  tags = {
    Name = "webapp-public-rt"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}
