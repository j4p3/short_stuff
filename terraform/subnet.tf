resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.default.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "${var.aws_region}a"

  tags = {
    Environment = var.environment_name
  }
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.default.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "${var.aws_region}c"

  tags = {
    Environment = var.environment_name
  }
}

resource "aws_subnet" "db_a" {
  vpc_id            = aws_vpc.default.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "${var.aws_region}a"

  tags = {
    Environment = var.environment_name
  }
}

resource "aws_subnet" "db_b" {
  vpc_id            = aws_vpc.default.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "${var.aws_region}c"

  tags = {
    Environment = var.environment_name
  }
}


resource "aws_db_subnet_group" "default" {
  name        = "${var.environment_name}-${var.name}-db"
  description = "Subnet group for DB"
  subnet_ids  = [aws_subnet.db_a.id, aws_subnet.db_b.id]

  tags = {
    Environment = var.environment_name
  }
}
