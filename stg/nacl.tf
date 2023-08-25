resource "aws_network_acl" "main" {
  vpc_id = aws_vpc.stg_vpc.id

  tags = {
    Name = "main_stg"
  }
}

resource "aws_network_acl_rule" "allow_all_inbound" {
  network_acl_id = aws_network_acl.main.id
  rule_number    = 100
  egress         = false
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}


resource "aws_network_acl_rule" "allow_all_outbound" {
  network_acl_id = aws_network_acl.main.id
  rule_number    = 100
  egress         = true
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_association" "a" {
  subnet_id      = aws_subnet.private_subnet_a.id
  network_acl_id = aws_network_acl.main.id
}

resource "aws_network_acl_association" "b" {
  subnet_id      = aws_subnet.private_subnet_b.id
  network_acl_id = aws_network_acl.main.id
}

resource "aws_network_acl_association" "c" {
  subnet_id      = aws_subnet.public_subnet_a.id
  network_acl_id = aws_network_acl.main.id
}

resource "aws_network_acl_association" "d" {
  subnet_id      = aws_subnet.public_subnet_b.id
  network_acl_id = aws_network_acl.main.id
}
