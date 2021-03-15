resource "aws_vpc" "myvpc" { # You could change this vpc name
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name    = "myProject"
    Project = "myProject"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "clients_1" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.available.names[0]

  tags = {
    Name    = "myProject"
    Project = "myProject"
  }
}

resource "aws_subnet" "clients_2" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.available.names[1]

  tags = {
    Name    = "myProject"
    Project = "myProject"
  }
}

resource "aws_subnet" "servers_1" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[0]
  tags = {
    Name    = "myProject"
    Project = "myProject"
  }
}

resource "aws_subnet" "servers_2" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[1]
  tags = {
    Name    = "myProject"
    Project = "myProject"
  }
}

resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name    = "myProject"
    Project = "myProject"
  }
}

resource "aws_eip" "Nat_IP" {
  vpc = true
  tags = {
    Name    = "myProject"
    Project = "myProject"
  }
}

resource "aws_nat_gateway" "NGW_1" {
  allocation_id = aws_eip.Nat_IP.id
  subnet_id     = aws_subnet.servers_1.id
  tags = {
    Name    = "myProject"
    Project = "myProject"
  }
}

resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }

  tags = {
    Name    = "myProject-public-route"
    Project = "myProject"
  }
}

resource "aws_route_table" "private_route" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.NGW_1.id
  }

  tags = {
    Name    = "myProject-private-route"
    Project = "myProject"
  }
}

resource "aws_route_table_association" "Route_association_Servers_1" {
  subnet_id      = aws_subnet.servers_1.id
  route_table_id = aws_route_table.public_route.id
}

resource "aws_route_table_association" "Route_association_Servers_2" {
  subnet_id      = aws_subnet.servers_2.id
  route_table_id = aws_route_table.public_route.id
}

resource "aws_route_table_association" "Route_association_clients_1" {
  subnet_id      = aws_subnet.clients_1.id
  route_table_id = aws_route_table.private_route.id
}


resource "aws_security_group" "ValheimTraffic" {
  name        = "ValheimTraffic"
  description = "Allow Valheim traffic"
  vpc_id      = aws_vpc.myvpc.id

  ingress {
    description = "Valheim Traffic UDP"
    from_port   = 2456
    to_port     = 2457
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Valheim Traffic TCP"
    from_port   = 2456
    to_port     = 2457
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
/*
  ingress {
    description = "Admin SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["yourIPaddress/32"] # here goes your IP public address
  }
*/
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "myProject-SG"
    Project = "myProject"
  }
}