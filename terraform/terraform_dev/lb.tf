resource "aws_lb" "shortstuff" {
  name = "${var.name}-${var.environment}"

  subnets = [
    aws_subnet.public.id,
    aws_subnet.private.id
  ]

  security_groups = [
    aws_security_group.http.id,
    aws_security_group.https.id,
    aws_security_group.egress-all.id
  ]

  tags = {
    app         = var.name
    environment = var.environment
  }
}

resource "aws_lb_target_group" "shortstuff" {
  port        = "4000"
  protocol    = "HTTP"
  vpc_id      = aws_vpc.default.id
  target_type = "ip"

  health_check {
    enabled = true
    path = "/health"
    matcher = "200"
    interval = 30
    unhealthy_threshold = 10
    timeout = 25
  }

  depends_on = [aws_lb.shortstuff]

  tags = {
    app         = var.name
    environment = var.environment
  }
}

resource "aws_lb_listener" "shortstuff_http" {
  load_balancer_arn = aws_lb.shortstuff.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.shortstuff.arn
    type             = "forward"
  }

  # default_action {
  #   type = "redirect"

  #   redirect {
  #     port        = "443"
  #     protocol    = "HTTPS"
  #     status_code = "HTTP_301"
  #   }
  # }
}

resource "aws_lb_listener" "shortstuff_https" {
  load_balancer_arn = aws_lb.shortstuff.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:acm:us-east-1:075531476457:certificate/b5cede04-fbb8-4feb-91b3-337e21d36f7d"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.shortstuff.arn
  }
}


