resource "aws_ecr_repository" "short_stuff" {
  name = "${var.environment_name}-${var.name}"
}
