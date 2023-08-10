resource "aws_lb" "fanc_alb_stg" {
  name               = "fanc-alb-stg"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_alb.id]
  subnets            = [aws_subnet.public_subnet_a.id, aws_subnet.public_subnet_b.id]

  enable_deletion_protection = true
  enable_http2               = true
  idle_timeout               = 60

  tags = {
    Name = "fanc-alb-stg"
  }
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.fanc_alb_stg.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.fanc_stg.arn
  }
}

resource "aws_lb_listener" "https_listener_stg" {
  load_balancer_arn = aws_lb.fanc_alb_stg.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = "arn:aws:acm:us-east-1:757245745517:certificate/1532a906-f277-4dd3-9a1b-14c1ae07ab8a"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.fanc_stg.arn
  }
}
