resource "aws_vpc" "main-vpc" {
  cidr_block = var.cidr_block_main_vpc

  tags = {
    Name = "main-vpc"
  }
}

resource "aws_subnet" "public-subnet-a" {
  vpc_id                  = aws_vpc.main-vpc.id
  cidr_block              = var.cidr_block_public_subnet_a
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true

  tags = {
    Name = "PublicSubnetA"
  }
}

resource "aws_subnet" "private-subnet-a" {
  vpc_id                  = aws_vpc.main-vpc.id
  cidr_block              = var.cidr_block_private_subnet_a
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = false

  tags = {
    Name = "PrivateSubnetA"
  }
}

resource "aws_internet_gateway" "internet-gateway" {
  vpc_id = aws_vpc.main-vpc.id
}

resource "aws_route_table" "public-subnet-a-route-table" {
  vpc_id = aws_vpc.main-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet-gateway.id
  }

  tags = {
    Name = "public-subnet-a-route-table"
  }
}

resource "aws_route_table_association" "public-subnet-a-and-route-table-association" {
  subnet_id      = aws_subnet.public-subnet-a.id
  route_table_id = aws_route_table.public-subnet-a-route-table.id
}


##Public Subnet B

resource "aws_subnet" "public-subnet-b" {
  vpc_id                  = aws_vpc.main-vpc.id
  cidr_block              = var.cidr_block_public_subnet_b
  availability_zone       = "${var.aws_region}b"
  map_public_ip_on_launch = true

  tags = {
    Name = "PublicSubnetB"
  }
}

resource "aws_route_table_association" "public-subnet-b-and-route-table-association" {
  subnet_id      = aws_subnet.public-subnet-b.id
  route_table_id = aws_route_table.public-subnet-a-route-table.id
}

##NAT Gateway A
resource "aws_eip" "aws-eip-nat-gateway-a" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat-gateway-a" {
  allocation_id = aws_eip.aws-eip-nat-gateway-a.id
  subnet_id     = aws_subnet.public-subnet-a.id

  tags = {
    Name = "NAT Gateway A"
  }

  depends_on = [aws_internet_gateway.internet-gateway]
}

##Private Subnet A route table

resource "aws_route_table" "private-subnet-a-route-table" {
  vpc_id = aws_vpc.main-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat-gateway-a.id
  }

  tags = {
    Name = "private-subnet-a-route-table"
  }
}



resource "aws_route_table_association" "private-subnet-a-and-route-table-association" {
  subnet_id      = aws_subnet.private-subnet-a.id
  route_table_id = aws_route_table.private-subnet-a-route-table.id
}


##Private Subnet B


resource "aws_subnet" "private-subnet-b" {
  vpc_id                  = aws_vpc.main-vpc.id
  cidr_block              = var.cidr_block_private_subnet_b
  availability_zone       = "${var.aws_region}b"
  map_public_ip_on_launch = false

  tags = {
    Name = "PrivateSubnetB"
  }
}



##NAT Gateway B
resource "aws_eip" "aws-eip-nat-gateway-b" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat-gateway-b" {
  allocation_id = aws_eip.aws-eip-nat-gateway-b.id
  subnet_id     = aws_subnet.public-subnet-b.id

  tags = {
    Name = "NAT Gateway B"
  }

  depends_on = [aws_internet_gateway.internet-gateway]
}

resource "aws_route_table" "private-subnet-b-route-table" {
  vpc_id = aws_vpc.main-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat-gateway-b.id
  }

  tags = {
    Name = "private-subnet-b-route-table"
  }
}



resource "aws_route_table_association" "private-subnet-b-and-route-table-association" {
  subnet_id      = aws_subnet.private-subnet-b.id
  route_table_id = aws_route_table.private-subnet-b-route-table.id
}