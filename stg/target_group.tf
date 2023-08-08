resource "aws_lb_target_group" "fanc_stg" {
  name     = "fanc-target-group-stg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.stg_vpc.id

  health_check {
    enabled             = true
    interval            = 30
    path                = "/healthcheck"
    port                = "traffic-port"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200"
  }

  tags = {
    Name = "fanc-target-group-stg"
  }
}
