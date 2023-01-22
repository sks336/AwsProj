provider "aws" {
  region = var.aws_region
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}


data "terraform_remote_state" "infra" {
  backend = "s3"
  config = {
    bucket = "${var.tfstate_bucket_name}"
    region = "${var.aws_region}"
    key = "${var.tfstate_path_infra}"
  }
}


resource "aws_route53_record" "kube" {
  allow_overwrite = true
  name            = "apicurio.thesachinshukla.com"
  ttl             = 3600
  type            = "A"
  zone_id         = var.hosted_zone_id

  records = [ data.terraform_remote_state.infra.outputs.kube-master-public-ip ]
}

resource "null_resource" "run_me_always" {
  triggers = {
    always_run = timestamp()
  }

  provisioner "file" {
    source      = "remote_resource_m02_apicurio_registry"
    destination = "/tmp"
    connection {
      host        = data.terraform_remote_state.infra.outputs.kube-master-public-ip
      type        = "ssh"
      port        = 22
      user        = "centos"
      private_key = "${file("/Users/sachin/work/keys/aws/sachin-aws-kp3.pem")}"
      timeout     = "2m"
      agent       = false
    }
  }

  provisioner "remote-exec" {
    inline = [
      "cp -rf /tmp/remote_resource_m02_apicurio_registry /home/centos && chmod +x /home/centos/remote_resource_m02_apicurio_registry/*.sh",
      "nohup /home/centos/remote_resource_m02_apicurio_registry/entrypoint.sh > /tmp/vm.log 2>&1 &",
      "sleep 10"
    ]
    connection {
      host        = data.terraform_remote_state.infra.outputs.kube-master-public-ip
      type        = "ssh"
      port        = 22
      user        = "centos"
      private_key = "${file("/Users/sachin/work/keys/aws/sachin-aws-kp3.pem")}"
      timeout     = "2m"
      agent       = false
    }
  }

}









#resource "aws_security_group" "apicurio-alb-sg" {
#  name = "terraform-apicurio-alb-sg"
#
#  ingress {
#    from_port   = 80
#    to_port     = 80
#    protocol    = "tcp"
#    cidr_blocks = ["0.0.0.0/0"]
#  }
#
#  egress {
#    from_port   = 0
#    to_port     = 0
#    protocol    = "-1"
#    cidr_blocks = ["0.0.0.0/0"]
#  }
#}
#
#resource "aws_lb" "apicurio-alb" {
#  name               = "terraform-apicurio-alb"
#  load_balancer_type = "application"
#  subnets            = data.aws_subnet_ids.default.ids
#  security_groups    = [aws_security_group.apicurio-alb-sg.id]
#}
#
#
#resource "aws_lb_target_group" "apicurio-alb-tg" {
#  name     = "terraform-apicurio-alb-tg"
#  port     = 80
#  protocol = "HTTP"
#  vpc_id   = data.aws_vpc.default.id
#
#
#  health_check {
#    path                = "/auth"
#    protocol            = "HTTP"
#    matcher             = "200,302"
#    interval            = 15
#    timeout             = 3
#    healthy_threshold   = 2
#    unhealthy_threshold = 2
#  }
#}
#
#resource "aws_lb_target_group_attachment" "lb-tg-attach" {
#  target_group_arn = aws_lb_target_group.apicurio-alb-tg.arn
#  target_id        = data.terraform_remote_state.infra.outputs.kube-master-id
#  port             = data.terraform_remote_state.infra.outputs.ingress-port
#}
#
#resource "aws_lb_listener" "http" {
#  load_balancer_arn = aws_lb.apicurio-alb.arn
#  port              = 80
#  protocol          = "HTTP"
#
#  # By default, return a simple 404 page
#  default_action {
#    type = "fixed-response"
#
#    fixed_response {
#      content_type = "text/plain"
#      message_body = "404: page not found"
#      status_code  = 404
#    }
#  }
#}
#
#resource "aws_lb_listener_rule" "asg" {
#  listener_arn = aws_lb_listener.http.arn
#  priority     = 100
#
#  condition {
#    path_pattern {
#      values = ["*"]
#    }
#  }
#
#  action {
#    type             = "forward"
#    target_group_arn = aws_lb_target_group.apicurio-alb-tg.arn
#  }
#}

