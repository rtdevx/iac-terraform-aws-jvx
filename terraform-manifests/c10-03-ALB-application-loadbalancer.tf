# INFO: Create Application Load Balancer - Host Header based Routing

# INFO: Create Application Load Balancer - Resource
# ? https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb

resource "aws_lb" "application_load_balancer" {
  name               = "${local.name}-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [
    aws_security_group.web-alb-private-80.id,
    aws_security_group.web-alb-private-443.id,
    aws_security_group.web-alb-private-egress.id
  ]

  subnets                    = module.vpc.public_subnets
  enable_deletion_protection = false

  tags = local.common_tags

}

# INFO: Application Load Balancer - Listeners
# ? https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener

# INFO: HTTP => HTTPS Redirect

resource "aws_lb_listener" "application_load_balancer_80_redirect" {
  load_balancer_arn = aws_lb.application_load_balancer.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {

    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# INFO: HTTPS Listener

resource "aws_lb_listener" "application_load_balancer_443" {
  depends_on        = [aws_acm_certificate_validation.cert] # NOTE: Must be present due to "Error: creating ELBv2 Listener" (cert validation)
  load_balancer_arn = aws_lb.application_load_balancer.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-Res-2021-06"
  certificate_arn   = aws_acm_certificate.cert.arn

  default_action {
    type = "forward"

    forward {
      target_group {
        arn    = aws_lb_target_group.private_target_group_8080_jvx.arn
        weight = 100
      }
      stickiness {
        enabled  = true
        duration = 600
      }
    }
  }
}

# INFO: Application Load Balancer - Target Groups
# ? https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group

# INFO: jvx
# * Only HTTP ports. SSL Termination at LB level. Out of scope for Terraform.

resource "aws_lb_target_group" "private_target_group_8080_jvx" {
  name        = "private-lb-tg-8080-jvx-${var.environment}"
  target_type = "instance"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = module.vpc.vpc_id

  stickiness {
    enabled         = true
    type            = "lb_cookie"
    cookie_duration = 60 # NOTE: Seconds
  }

  health_check {
    enabled             = true
    interval            = 30
    path                = "/" # changed from /opt/jvx.jar to root endpoint
    port                = "8080"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 6
    protocol            = "HTTP"
    matcher             = "200-399"
  }
}

# INFO: Application Load Balancer - Auto Scaling Target Groups Attach
# ? https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_attachment

resource "aws_autoscaling_attachment" "my_asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.my_asg.id
  lb_target_group_arn    = aws_lb_target_group.private_target_group_8080_jvx.arn
}

# INFO: Application Load Balancer - Listener Rules
# ? https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule

# INFO: jvx
# * Weighted Forward action

resource "aws_lb_listener_rule" "host_based_routing_jvx" {
  listener_arn = aws_lb_listener.application_load_balancer_443.arn
  priority     = 1

  action {
    type = "forward"
    forward {
      target_group {
        arn    = aws_lb_target_group.private_target_group_8080_jvx.arn
        weight = 100
      }
      stickiness {
        enabled  = true
        duration = 600
      }
    }
  }

  condition {
    path_pattern {
      values = ["/opt/jvx.jar", "/opt/jvx.jar*"]
    }
  }
}