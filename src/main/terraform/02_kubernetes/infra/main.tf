provider "aws" {
  region = var.region
}

resource "aws_instance" "kube-master" {
  ami           = var.ami_image
  instance_type = var.instance-type
  key_name = "sachin-aws-kp"
  security_groups = [aws_security_group.kube-ports.name, aws_security_group.basic-ports.name]

  provisioner "file" {
    source      = "remote_resources"
    destination = "/tmp"
    connection {
      host        = coalesce(self.public_ip, self.private_ip)
      type        = "ssh"
      port        = 22
      user        = "centos"
      private_key = "${file("/Users/sachin/work/aws/sachin-aws-kp.pem")}"
      timeout     = "2m"
      agent       = false
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo cp -rf /tmp/remote_resources /home/centos",
      "sudo chmod +x /home/centos/remote_resources/*.sh",
      "sudo chown -R centos. /home/centos",
      "sudo /bin/sh -c /home/centos/remote_resources/setup_master.sh"
    ]
    connection {
      host        = coalesce(self.public_ip, self.private_ip)
      type        = "ssh"
      port        = 22
      user        = "centos"
      private_key = "${file("/Users/sachin/work/aws/sachin-aws-kp.pem")}"
      timeout     = "2m"
      agent       = false
    }
  }

  tags = {
    Name = "kube-master"
  }
}


locals {
  ports_in = [ 22, 80, 443, 8080 ]
  ports_out = [ 0 ]
}

resource "aws_security_group" "basic-ports" {
  name = "terraform-basic-ports"

  dynamic "ingress" {
    for_each = toset(local.ports_in)
    content {
      description      = "HTTPS from VPC"
      from_port        = ingress.value
      to_port          = ingress.value
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
    }
  }

  dynamic "egress" {
    for_each = toset(local.ports_out)
    content {
      from_port        = egress.value
      to_port          = egress.value
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
    }
  }
}

resource "aws_security_group" "kube-ports" {
  name = "terraform-kube-node-ports"

  ingress {
    description      = "Allow All-ingress"
    from_port        = 30000
    to_port          = 32700
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    description      = "Allow All-egress"
    from_port        = 0
    to_port          = 65535
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

data "external" "kube-ingress-port" {
  depends_on = [aws_instance.kube-master]
  program = ["/bin/sh", "-c", "remote_resources/external_datasource_for_ingress_service_port.sh"]
}

resource "aws_route53_record" "kube" {
  allow_overwrite = true
  name            = "kube.thesachinshukla.com"
  ttl             = 3600
  type            = "A"
  zone_id         = var.hosted_zone_id

  records = [ aws_instance.kube-master.public_ip ]
}