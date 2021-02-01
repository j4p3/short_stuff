resource "aws_ecr_repository" "shortstuff" {
  name = "${var.name}"

  tags = {
    app         = var.name
    environment = var.environment
  }
}
