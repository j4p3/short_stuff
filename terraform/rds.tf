resource "aws_db_instance" "default" {
  allocated_storage = var.db_storage
  engine            = var.db_engine
  engine_version    = var.db_engine_version
  instance_class    = var.db_instance_type
  name              = var.db_name
  username          = var.db_username
  password          = var.db_password

  availability_zone = var.aws_default_zone

  publicly_accessible    = false
  vpc_security_group_ids = [aws_security_group.db.id]
  db_subnet_group_name   = aws_db_subnet_group.default.name

  tags = {
    App         = var.name
    Environment = var.environment_name
  }
}
