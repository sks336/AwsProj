provider "aws" {
  region = var.region
}

data "terraform_remote_state" "infra" {
  backend = "s3"
  config = {
    bucket = "${var.bucket-name}"
    region = "${var.region}"
    key = "${var.tfstate-path-infra}"
  }
}

data "external" "kube-ingress-port" {
  program = ["/bin/sh", "-c", "remote_resources/external_datasource_for_ingress_service_port.sh"]
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

resource "aws_security_group" "kube-alb-sg" {
  name = "terraform-kube-alb-sg"

  ingress {
    from_port   = 80
    to_port     = 80
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

resource "aws_lb" "kube-alb" {
  name               = "terraform-kube-alb"
  load_balancer_type = "application"
  subnets            = data.aws_subnet_ids.default.ids
  security_groups    = [aws_security_group.kube-alb-sg.id]
}


resource "aws_lb_target_group" "kube-alb-tg" {
  name     = "terraform-kube-alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id


  health_check {
    path                = "/test"
    protocol            = "HTTP"
    matcher             = "200,302"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_target_group_attachment" "lb-tg-attach" {
  target_group_arn = aws_lb_target_group.kube-alb-tg.arn
  target_id        = data.terraform_remote_state.infra.outputs.kube-master-id
  port             = data.external.kube-ingress-port.result["ingress_port"]
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.kube-alb.arn
  port              = 80
  protocol          = "HTTP"

  # By default, return a simple 404 page
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code  = 404
    }
  }
}

resource "aws_lb_listener_rule" "asg" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.kube-alb-tg.arn
  }
}