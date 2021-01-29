resource "aws_ecr_repository" "myapp_repo" {
  name = "${var.environment_name}-${var.name}"
}
