resource "aws_vpc" "stg_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name        = "fanc-stg-default-vpc"
    Environment = "staging"
  }
}
