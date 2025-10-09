# -------------------------------
# Security Group for ALB
# -------------------------------
resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Allow HTTPS inbound"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# -------------------------------
# ALB
# -------------------------------
resource "aws_lb" "kube_alb" {
  name               = "kube-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [var.subnet_id_a_prv, var.subnet_id_a_pub]
}

# -------------------------------
# Target Group for KUBE
# -------------------------------
resource "aws_lb_target_group" "kube_tg" {
  name        = "kube-tg"
  port        = var.app_port_keycloak
  protocol    = "HTTPS"
  target_type = "instance"
  vpc_id      = var.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTPS"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2

    # Accept both 200 and 302 as healthy
    matcher = "200-308"
  }
}

# Attach instances to the target group
resource "aws_lb_target_group_attachment" "keycloak_tg_attach" {
  for_each = {
    control_plane = aws_instance.kube_node_control_plane.id
    worker0       = aws_instance.kube_node_workers[0].id
  }

  target_group_arn = aws_lb_target_group.kube_tg.arn
  target_id        = each.value
  port             = var.app_port_keycloak
}

# -------------------------------
# ALB Listener for HTTPS
# -------------------------------
resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.kube_alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.acm_certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.kube_tg.arn
  }

  # Optional host-based routing (if you want multiple host rules later)
  # Uncomment if you add more host rules
  # dynamic "default_action" {
  #   for_each = [var.host]
  #   content {
  #     type             = "forward"
  #     target_group_arn = aws_lb_target_group.keycloak_tg.arn
  #   }
  # }
}

# -------------------------------
# Route53 DNS Record
# -------------------------------
resource "aws_route53_record" "keycloak_dns" {
  zone_id = var.hosted_zone_id
  name    = var.host_keycloak
  type    = "A"

  alias {
    name                   = aws_lb.kube_alb.dns_name
    zone_id                = aws_lb.kube_alb.zone_id
    evaluate_target_health = true
  }
}
