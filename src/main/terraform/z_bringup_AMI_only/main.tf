provider "aws" {
  region = var.aws_region
}

data "aws_vpc" "default" {
  default = true
}

locals {
  allowed_ports = [22, 80, 443, 3000]
}


resource "aws_security_group" "allowed_ports" {
  name = "sg_allowed_port_ranges"
  vpc_id = data.aws_vpc.default.id

  dynamic "ingress" {
    for_each = local.allowed_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = [ "0.0.0.0/0" ]
    }
  }

  ingress {
    from_port       = 8000
    to_port         = 9000
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}


# ---------------------------------------------------------------------------------

resource "aws_instance" "instance" {
  ami           = var.ami_image
  instance_type = var.instance_type
  key_name = "sachin-kp"
  vpc_security_group_ids = [aws_security_group.allowed_ports.id]

  tags = {
    Name = "tf-img"
    usecase = "testing-${var.aws_region}"
  }
}


resource "null_resource" "run_me_always" {
  depends_on = [aws_instance.instance]
  triggers = {
    always_run = timestamp()
  }

  connection {
    host        = aws_instance.instance.public_ip
    type        = "ssh"
    port        = 22
    user        = "ubuntu"
    private_key = "${file("/Users/sachin/work/keys/aws/sjlearning_2024/sachin-kp.pem")}"
    timeout     = "2m"
    agent       = false
  }

  provisioner "file" {
    source      = "resources_z_bringupAMI"
    destination = "/tmp"
  }


  provisioner "remote-exec" {

    inline = [
      "chmod +x /tmp/resources_z_bringupAMI/scripts/init.sh",
      "sudo -H -u sachin /tmp/resources_z_bringupAMI/scripts/init.sh"
    ]
  }
}

