resource "aws_instance" "bastion" {
  ami                    = "ami-0f34c5ae932e6f0e4"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnet_a.id
  vpc_security_group_ids = [aws_security_group.bastion.id]
  key_name               = "fanc-stg-keypair"

  tags = {
    Name = "bastion_stg"
  }
}
