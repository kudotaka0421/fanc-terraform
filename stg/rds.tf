resource "aws_db_instance" "default" {
  identifier = "fanc-db-stg"

  engine            = "mysql"
  engine_version    = "8.0.32"
  instance_class    = "db.t3.micro"
  allocated_storage = 20

  db_name  = var.MYSQL_DATABASE
  username = var.db_username
  password = var.db_password
  port     = "3306"

  vpc_security_group_ids = [aws_security_group.db.id]
  db_subnet_group_name   = aws_db_subnet_group.main_stg.name

  backup_retention_period = 0
  skip_final_snapshot     = true
  apply_immediately       = true

  parameter_group_name = "default.mysql8.0"

  //prodはここtrueで良い
  multi_az = false

  storage_type          = "gp2"
  max_allocated_storage = 40
  publicly_accessible   = true

  tags = {
    Name = "FANC-DB-STG"
  }

  depends_on = [aws_internet_gateway.stg_igw]
}

resource "aws_db_subnet_group" "main_stg" {
  name       = "main"
  subnet_ids = [aws_subnet.private_subnet_a.id, aws_subnet.private_subnet_b.id]

  tags = {
    Name = "fanc-database-subnet-group-stg"
  }
}
// rds.tf

output "db_endpoint" {
  description = "The connection endpoint"
  value       = aws_db_instance.default.endpoint
}

output "db_port" {
  description = "The database port"
  value       = aws_db_instance.default.port
}
