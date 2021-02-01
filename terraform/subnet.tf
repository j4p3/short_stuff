resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.default.id
  cidr_block = "10.0.1.0/24"

  tags = {
    app         = var.name
    environment = var.environment
    name        = "public"
  }
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.default.id
  cidr_block = "10.0.2.0/24"

  tags = {
    app         = var.name
    environment = var.environment
    name        = "private"
  }
}

resource "aws_subnet" "db_a" {
  vpc_id            = aws_vpc.default.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "${var.aws_region}a"

  tags = {
    app         = var.name
    environment = var.environment
    name        = "db_a"
  }
}

resource "aws_subnet" "db_c" {
  vpc_id            = aws_vpc.default.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "${var.aws_region}c"

  tags = {
    app         = var.name
    environment = var.environment
    name        = "db_c"
  }
}


resource "aws_db_subnet_group" "default" {
  name        = "${var.name}-${var.environment}-db"
  description = "Subnet group for DB"
  subnet_ids  = [aws_subnet.db_a.id, aws_subnet.db_c.id]

  tags = {
    app         = var.name
    environment = var.environment
  }
}
