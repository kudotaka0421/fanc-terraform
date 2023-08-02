resource "aws_internet_gateway" "stg_igw" {
  vpc_id = aws_vpc.stg_vpc.id

  tags = {
    Name        = "fanc-stg-igw"
    Environment = "staging"
  }
}
