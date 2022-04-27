locals {
  ports_in = var.allowed_ingress_ports
  ports_out = [ 0 ]
}

resource "aws_security_group" "basic-ports" {
  name = "basic-ports"
  vpc_id = aws_vpc.my_vpc.id

  dynamic "ingress" {
    for_each = toset(local.ports_in)
    content {
      description      = "HTTPS from VPC"
      from_port        = ingress.value
      to_port          = ingress.value
      protocol         = "tcp"
      cidr_blocks      = [var.allow_all_cidr]
    }
  }

  dynamic "egress" {
    for_each = toset(local.ports_out)
    content {
      from_port        = egress.value
      to_port          = egress.value
      protocol         = "-1"
      cidr_blocks      = [var.allow_all_cidr]
    }
  }

  tags = {
    Name = "basic-ports"
  }
}