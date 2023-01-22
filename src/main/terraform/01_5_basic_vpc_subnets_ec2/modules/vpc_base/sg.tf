locals {
  ports_in = var.allow_all_ingress_ports
  ports_out = [ 0 ]
}

resource "aws_security_group" "allow_all_ingress_ports" {
  name = "allow_all_ingress_ports"
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
    Name = "allow_all_ingress_ports"
  }
}

resource "aws_security_group" "unsercure_sg" {
  name = "unsercure_sg"
  vpc_id = aws_vpc.my_vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "unsercure_sg"
  }
}