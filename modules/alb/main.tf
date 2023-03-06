# create application load balancer
resource "aws_lb" "application_load_balancer" {
  name               = "${}-alb"
  internal           = 
  load_balancer_type = 
  security_groups    = []
  subnets            = []
  enable_deletion_protection = 

  tags   = {
    Name = "${}-alb"
  }
}

# create target group
resource "aws_lb_target_group" "alb_target_group" {
  name        = "${}-tg"
  target_type = 
  port        = 
  protocol    = 
  vpc_id      = 

  health_check {
    enabled             = true
    interval            = 300
    path                = "/"
    timeout             = 60
    matcher             = 200
    healthy_threshold   = 5
    unhealthy_threshold = 5
  }

  lifecycle {
    create_before_destroy = 
  }
}

# create a listener on port 80 with redirect action
resource "aws_lb_listener" "alb_http_listener" {
  load_balancer_arn = 
  port              = 
  protocol          = 

  default_action {
    type = "redirect"

    redirect {
      port        = 443
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# create a listener on port 443 with forward action
resource "aws_lb_listener" "alb_https_listener" {
  load_balancer_arn  = 
  port               = 
  protocol           = 
  ssl_policy         = "ELBSecurityPolicy-2016-08"
  certificate_arn    = 

  default_action {
    type             = 
    target_group_arn = 
  }
}