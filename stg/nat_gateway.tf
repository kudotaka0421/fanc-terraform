resource "aws_eip" "nat_eip_a" {
  domain = "vpc"
  tags = {
    Name = "fanc_nat_eip_a_stg"
  }
}


resource "aws_nat_gateway" "nat_gateway_a" {
  allocation_id = aws_eip.nat_eip_a.id
  subnet_id     = aws_subnet.public_subnet_a.id

  tags = {
    Name = "fanc_nat_gateway_a_stg"
  }
}

resource "aws_eip" "nat_eip_b" {
  domain = "vpc"
  tags = {
    Name = "fanc_nat_eip_b_stg"
  }
}

resource "aws_nat_gateway" "nat_gateway_b" {
  allocation_id = aws_eip.nat_eip_b.id
  subnet_id     = aws_subnet.public_subnet_b.id

  tags = {
    Name = "fanc_nat_gateway_b_stg"
  }
}

resource "aws_route_table" "private_a" {
  vpc_id = aws_vpc.stg_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway_a.id
  }

  tags = {
    Name = "fanc_private_route_table_a_stg"
  }
}

resource "aws_route_table" "private_b" {
  vpc_id = aws_vpc.stg_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway_b.id
  }

  tags = {
    Name = "fanc_private_route_table_b_stg"
  }
}

resource "aws_route_table_association" "private_a" {
  subnet_id      = aws_subnet.private_subnet_a.id
  route_table_id = aws_route_table.private_a.id
}

resource "aws_route_table_association" "private_b" {
  subnet_id      = aws_subnet.private_subnet_b.id
  route_table_id = aws_route_table.private_b.id
}
