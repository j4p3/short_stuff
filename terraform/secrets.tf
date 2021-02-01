data "template_file" "task_template_secretsmanager" {
  template = file("./templates/${var.name}-${var.environment}-task.json.tpl")

  vars = {
    mix_env                = var.environment
    db_name                = aws_db_instance.main.name
    db_user                = aws_db_instance.main.username
    db_host                = aws_db_instance.main.address
    hostname               = aws_lb.shortstuff.dns_name
    repository_url         = aws_ecr_repository.shortstuff.repository_url
    task_name              = "${var.name}-${var.environment}"
    log_group              = aws_cloudwatch_log_group.shortstuff.name
    log_region             = var.aws_region
    admin_user             = var.admin_user
    db_password_secret     = aws_secretsmanager_secret.database_password_secret.arn
    secret_key_base_secret = aws_secretsmanager_secret.secret_key_base.arn
    signing_salt_secret    = aws_secretsmanager_secret.signing_salt.arn
    admin_password_secret  = aws_secretsmanager_secret.admin_password.arn
  }
}

# Enable to debug policy rendering
# output "rendered_policy" {
#   value = data.template_file.task_template_secretsmanager.rendered
# }


data "aws_iam_policy_document" "password_policy_secretsmanager" {
  statement {
    actions = ["secretsmanager:GetSecretValue"]
    resources = [
      aws_secretsmanager_secret.database_password_secret.arn,
      aws_secretsmanager_secret.secret_key_base.arn,
      aws_secretsmanager_secret.signing_salt.arn,
      aws_secretsmanager_secret.admin_password.arn,
    ]
  }
}


resource "aws_secretsmanager_secret" "database_password_secret" {
  name = "${var.name}-${var.environment}-db-password"

  tags = {
    app         = var.name
    environment = var.environment
  }
}

resource "aws_secretsmanager_secret_version" "database_password_secret_version" {
  secret_id     = aws_secretsmanager_secret.database_password_secret.id
  secret_string = var.db_password
}

resource "aws_secretsmanager_secret" "secret_key_base" {
  name = "${var.name}-${var.environment}-secret-key-base"

  tags = {
    app         = var.name
    environment = var.environment
  }
}

resource "aws_secretsmanager_secret_version" "secret_key_base_version" {
  secret_id     = aws_secretsmanager_secret.secret_key_base.id
  secret_string = var.secret_key_base
}

resource "aws_secretsmanager_secret" "signing_salt" {
  name = "${var.name}-${var.environment}-signing-salt"

  tags = {
    app         = var.name
    environment = var.environment
  }
}

resource "aws_secretsmanager_secret_version" "signing_salt_version" {
  secret_id     = aws_secretsmanager_secret.signing_salt.id
  secret_string = var.signing_salt
}

resource "aws_secretsmanager_secret" "admin_password" {
  name = "${var.name}-${var.environment}-admin-password"

  tags = {
    app         = var.name
    environment = var.environment
  }
}

resource "aws_secretsmanager_secret_version" "admin_password_version" {
  secret_id     = aws_secretsmanager_secret.admin_password.id
  secret_string = var.admin_password
}

resource "aws_iam_policy" "password_policy_secretsmanager" {
  name = "password-policy-secretsmanager"

  policy = data.aws_iam_policy_document.password_policy_secretsmanager.json
}
