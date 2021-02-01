resource "aws_ecr_repository" "shortstuff" {
  name = "${var.name}-${var.environment}"

  tags = {
    app         = var.name
    environment = var.environment
  }
}
