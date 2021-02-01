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
  name               = "${var.name}-${var.environment}-task-role-ecs"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_exec_role.json

  tags = {
    app         = var.name
    environment = var.environment
  }
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

resource "aws_cloudwatch_log_group" "shortstuff" {
  name = "/fargate/${var.name}-${var.environment}"

  tags = {
    app         = var.name
    environment = var.environment
  }
}

# Cluster

resource "aws_ecs_cluster" "default" {
  depends_on         = [aws_cloudwatch_log_group.shortstuff]
  name               = "${var.name}-${var.environment}"
  capacity_providers = ["FARGATE"]

  tags = {
    app         = var.name
    environment = var.environment
  }
}

# Task definition for the application

resource "aws_ecs_task_definition" "shortstuff" {
  family                   = "${var.name}-${var.environment}"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.ecs_fargate_application_cpu
  memory                   = var.ecs_fargate_application_mem
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.ecs_task_exec_role.arn
  container_definitions    = data.template_file.task_template_secretsmanager.rendered
  
  tags = {
    app         = var.name
    environment = var.environment
  }
}


resource "aws_ecs_service" "shortstuff" {
  name            = "${var.name}-${var.environment}-service"
  cluster         = aws_ecs_cluster.default.id
  launch_type     = "FARGATE"
  task_definition = aws_ecs_task_definition.shortstuff.arn
  desired_count   = var.ecs_application_count

  load_balancer {
    target_group_arn = aws_lb_target_group.shortstuff.arn
    container_name   = "${var.name}-${var.environment}"
    container_port   = 4000
  }

  network_configuration {
    assign_public_ip = true

    security_groups = [
      aws_security_group.egress-all.id,
      aws_security_group.shortstuff_service.id
    ]
    subnets = [aws_subnet.private.id]
  }

  depends_on = [
    aws_lb_listener.shortstuff_http,
    aws_lb_listener.shortstuff_https,
    aws_ecs_task_definition.shortstuff
  ]

  tags = {
    app         = var.name
    environment = var.environment
  }
}
