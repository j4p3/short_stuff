resource "aws_lb" "short_stuff" {
  name = "${var.environment_name}-${var.name}"

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
    Environment = var.environment_name
  }
}

resource "aws_acm_certificate" "short_stuff" {
  domain_name       = "isthesqueezesquoze.com"
  validation_method = "DNS"

  tags = {
    Environment = var.environment_name
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_target_group" "short_stuff" {
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

  tags = {
    Environment = var.environment_name
  }

  depends_on = [aws_lb.short_stuff]
}

resource "aws_lb_listener" "short_stuff_http" {
  load_balancer_arn = aws_lb.short_stuff.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.short_stuff.arn
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

resource "aws_lb_listener" "short_stuff_https" {
  load_balancer_arn = aws_lb.short_stuff.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.short_stuff.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.short_stuff.arn
  }
}


