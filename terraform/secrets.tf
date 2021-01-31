data "template_file" "task_template_secretsmanager" {
  template = file("./templates/${var.environment_name}-${var.name}-task.json.tpl")

  vars = {
    db_name        = var.db_name
    db_username    = var.db_username
    db_host        = aws_db_instance.default.address
    db_password    = aws_secretsmanager_secret.database_password_secret.arn
    repository_url = aws_ecr_repository.short_stuff.repository_url
    task_name      = "${var.environment_name}-${var.name}"
    log_group      = aws_cloudwatch_log_group.short_stuff.name
    log_region     = var.aws_region
  }
}

# Enable to debug policy rendering
# output "rendered_policy" {
#   value = data.template_file.task_template_secretsmanager.rendered
# }


data "aws_iam_policy_document" "password_policy_secretsmanager" {
  statement {
    actions   = ["secretsmanager:GetSecretValue"]
    resources = [aws_secretsmanager_secret.database_password_secret.arn]
  }
}


resource "aws_secretsmanager_secret" "database_password_secret" {
  name = "${var.environment_name}-${var.name}-db-password"
}

resource "aws_secretsmanager_secret_version" "database_password_secret_version" {
  secret_id     = aws_secretsmanager_secret.database_password_secret.id
  secret_string = var.db_password
}

resource "aws_iam_policy" "password_policy_secretsmanager" {
  name = "password-policy-secretsmanager"

  policy = data.aws_iam_policy_document.password_policy_secretsmanager.json
}
