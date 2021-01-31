# Role for ECS task
# This is because our Fargate ECS must be able to pull images from ECS
# and put logs from application container to log driver

data "aws_iam_policy_document" "ecs_task_exec_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_task_exec_role" {
  name               = "${var.environment_name}-${var.name}-task-role-ecs"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_exec_role.json
}

resource "aws_iam_role_policy_attachment" "ecs_task_exec_role_ecs" {
  role       = aws_iam_role.ecs_task_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "ecs_task_exec_role_secrets" {
  role       = aws_iam_role.ecs_task_exec_role.name
  policy_arn = aws_iam_policy.password_policy_secretsmanager.arn
}

# Cloudwatch logs

resource "aws_cloudwatch_log_group" "short_stuff" {
  name = "/fargate/${var.environment_name}-${var.name}"
}

# Cluster

resource "aws_ecs_cluster" "default" {
  depends_on         = [aws_cloudwatch_log_group.short_stuff]
  name               = "${var.environment_name}-${var.name}"
  capacity_providers = ["FARGATE"]
}

# Task definition for the application

resource "aws_ecs_task_definition" "short_stuff" {
  family                   = "${var.environment_name}-${var.name}"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.ecs_fargate_application_cpu
  memory                   = var.ecs_fargate_application_mem
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.ecs_task_exec_role.arn
  container_definitions    = data.template_file.task_template_secretsmanager.rendered
}


resource "aws_ecs_service" "short_stuff" {
  name            = "${var.environment_name}-${var.name}-service"
  cluster         = aws_ecs_cluster.default.id
  launch_type     = "FARGATE"
  task_definition = aws_ecs_task_definition.short_stuff.arn
  desired_count   = var.ecs_application_count

  load_balancer {
    target_group_arn = aws_lb_target_group.short_stuff.arn
    container_name   = "${var.environment_name}-${var.name}"
    container_port   = 4000
  }

  network_configuration {
    assign_public_ip = false

    security_groups = [
      aws_security_group.egress-all.id,
      aws_security_group.short_stuff-service.id
    ]
    subnets = [aws_subnet.private.id]
  }

  depends_on = [
    aws_lb_listener.short_stuff_http,
    aws_lb_listener.short_stuff_https,
    aws_ecs_task_definition.short_stuff
  ]
}
