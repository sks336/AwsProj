provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "ec2_instance" {
  ami           = var.ami_img
  instance_type = var.instance_type
  key_name = "sachin-aws-kp2"
  security_groups = [aws_security_group.allowed-ports.name]

  root_block_device {
    delete_on_termination = true
    encrypted = false
    volume_size = var.root_block_device_volume_size_in_GB
    volume_type = var.root_block_device_volume_type
  }
  tags = {
    usecase = "apicurio-${var.aws_region}"
  }
}

resource "null_resource" "run_me_always" {
  depends_on = [aws_security_group.allowed-ports]
  triggers = {
    always_run = timestamp()
  }

  provisioner "file" {
    source      = "remote_resources_05_apicurio"
    destination = "/tmp"
    connection {
      host        = aws_instance.ec2_instance.public_ip
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
#      "yum install unzip -y",
      "cp -rf /tmp/remote_resources_05_apicurio /home/centos",
      "chmod +x /home/centos/remote_resources_05_apicurio/*.sh",
      "nohup /home/centos/remote_resources_05_apicurio/entrypoint.sh > /tmp/vm.log 2>&1 &",
      "sleep 40"
    ]
    connection {
      host        = aws_instance.ec2_instance.public_ip
      type        = "ssh"
      port        = 22
      user        = "centos"
      private_key = "${file("/Users/sachin/work/keys/aws/sachin-aws-kp3.pem")}"
      timeout     = "2m"
      agent       = false
    }

  }
}


locals {
  ports_in = var.allowed_ingress_ports
  ports_out = [0]
}

resource "aws_security_group" "allowed-ports" {
  name = "terraform-allowed-ports-apicurio"

  dynamic "ingress" {
    for_each = toset(local.ports_in)
    content {
      description      = "HTTPS from VPC"
      from_port        = ingress.value
      to_port          = ingress.value
      protocol         = "tcp"
      cidr_blocks      = var.allowed_ip_ranges
    }
  }

  egress {
    description      = "Allow All-egress-apicurio"
    from_port        = 0
    to_port          = 65535
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}


