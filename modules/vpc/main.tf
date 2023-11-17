resource "aws_vpc" "main_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true

  tags = {
    Name = "${var.app_name}-${var.environment_name}-vpc"
  }
}


resource "aws_subnet" "subnet_public" {
  for_each          = var.subnets-public
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = each.value.cidr
  availability_zone = var.availability_zones[index(keys(var.subnets-public), each.key)]
  tags = {
    Name = "${var.app_name}-${var.environment_name}-${each.key}"
  }
}


resource "aws_subnet" "subnet_private" {
  for_each          = var.subnets-private
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = each.value.cidr
  availability_zone = var.availability_zones[index(keys(var.subnets-private), each.key)]
  tags = {
    Name = "${var.app_name}-${var.environment_name}-${each.key}"
  }
}



resource "aws_route_table" "main_private_rt" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "${var.app_name}-${var.environment_name}-private-rt"
  }
}

resource "aws_route_table" "main_public_rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_igw.id
  }

  tags = {
    Name = "${var.app_name}-${var.environment_name}-public-rt"
  }
}


resource "aws_route_table_association" "main_aws_public_assosiation" {
  for_each = var.subnets-public

  subnet_id      = aws_subnet.subnet_public[each.key].id
  route_table_id = aws_route_table.main_public_rt.id
}


resource "aws_route_table_association" "main_aws_private_assosiation" {
  for_each = var.subnets-private

  subnet_id      = aws_subnet.subnet_private[each.key].id
  route_table_id = aws_route_table.main_private_rt.id
}


resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "${var.app_name}-${var.environment_name}-igw"
  }
}


resource "aws_security_group" "main_securitygroup" {
  name        = "${var.app_name}-${var.environment_name}-vpc-sg"
  description = "This is Project Security Group"
  vpc_id      = aws_vpc.main_vpc.id

  dynamic "ingress" {
    for_each = var.main_securitygroup_ingress
    content {
      description = ingress.value.description
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  dynamic "egress" {
    for_each = var.main_securitygroup_egress
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }
}


resource "aws_nat_gateway" "main_nat_gateway" {
  allocation_id = aws_eip.main_nat_gateway_eip.id

  # Access the first subnet's ID
  subnet_id     = aws_subnet.subnet_public[keys(var.subnets-public)[0]].id

  tags = {
    Name = "gw NAT"
  }

  # Explicit dependency on the Internet Gateway
  depends_on = [aws_internet_gateway.main_igw]
}


resource "aws_eip" "main_nat_gateway_eip" {
  domain = "vpc"
  tags = {
    Name = "EIP for NAT Gateway"
  }
}