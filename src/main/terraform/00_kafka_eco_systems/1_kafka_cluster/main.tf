provider "aws" {
  region = var.aws_region
}

data "aws_vpc" "default" {
  default = true
}

locals {
  allowed_ports = [22, 80, 3000, 8080, 443, 7071, 9090, 9092, 9097]
}


resource "aws_security_group" "allowed_ports" {
  name = "sg_allowed_ports"
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

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

# ----------------------------------------------------

resource "aws_instance" "instance_master" {
  count         = var.master_node_count
  ami           = var.ami_image
  instance_type = var.master_instance_type
  key_name = var.pem_key_name
  vpc_security_group_ids = [aws_security_group.allowed_ports.id]

  tags = {
    Name = "kafka-master"
    usecase = "testing-${var.aws_region}"
  }
}

resource "aws_instance" "instance_workers" {
  depends_on = [aws_instance.instance_master]
  count         = var.worker_nodes_count
  ami           = var.ami_image
  instance_type = var.instance_type
  key_name = var.pem_key_name
  vpc_security_group_ids = [aws_security_group.allowed_ports.id]

  tags = {
    Name = "kafka-worker-${count.index+1}"
    usecase = "testing-${var.aws_region}"
  }
}


resource "null_resource" "run_me_always_master" {
  count = var.master_node_count
  depends_on = [aws_instance.instance_workers]
  triggers = {
    always_run = timestamp()
  }

  connection {
    host        = aws_instance.instance_master[count.index].public_ip
    type        = "ssh"
    port        = 22
    user        = "ubuntu"
    private_key = file("${var.pem_file}")
    timeout     = "2m"
    agent       = false
  }

  provisioner "file" {
    source      = "resources_00_tmp"
    destination = "/tmp"
  }


  provisioner "remote-exec" {

    inline = [
      "chmod +x /tmp/resources_00_tmp/init.sh",
      "sudo -H -u kafka /tmp/resources_00_tmp/init.sh ${count.index+1} 1@${aws_instance.instance_master[0].private_ip}:9097,2@${aws_instance.instance_workers[0].private_ip}:9097,3@${aws_instance.instance_workers[1].private_ip}:9097 PLAINTEXT://${aws_instance.instance_master[0].public_ip}:9092 ${aws_instance.instance_master[0].private_ip} ${aws_instance.instance_master[count.index].public_ip}"
    ]
  }
}

# ------------------------------------------------------------------------


resource "null_resource" "run_me_always_workers" {
  count = var.worker_nodes_count
  depends_on = [null_resource.run_me_always_master]
  triggers = {
    always_run = timestamp()
  }

  connection {
    host        = aws_instance.instance_workers[count.index].public_ip
    type        = "ssh"
    port        = 22
    user        = "ubuntu"
    private_key = file("${var.pem_file}")
    timeout     = "2m"
    agent       = false
  }

  provisioner "file" {
    source      = "resources_00_tmp"
    destination = "/tmp"
  }


  provisioner "remote-exec" {

    inline = [

      "chmod +x /tmp/resources_00_tmp/init.sh",
      "sudo -H -u kafka /tmp/resources_00_tmp/init.sh ${count.index+2} 1@${aws_instance.instance_master[0].private_ip}:9097,2@${aws_instance.instance_workers[0].private_ip}:9097,3@${aws_instance.instance_workers[1].private_ip}:9097 PLAINTEXT://${aws_instance.instance_master[0].public_ip}:9092 ${aws_instance.instance_master[0].private_ip} ${aws_instance.instance_workers[count.index].public_ip}"
    ]
  }
}




resource "null_resource" "run_me_always_monitoring" {
  count = var.master_node_count
  depends_on = [null_resource.run_me_always_workers]
  triggers = {
    always_run = timestamp()
  }

  connection {
    host        = aws_instance.instance_master[count.index].public_ip
    type        = "ssh"
    port        = 22
    user        = "ubuntu"
    private_key = file("${var.pem_file}")
    timeout     = "2m"
    agent       = false
  }

  provisioner "remote-exec" {

    inline = [
      "sudo -H -u kafka /home/kafka/resources_00_tmp/scripts/setup_monitoring.sh ${aws_instance.instance_master[0].private_ip} ${aws_instance.instance_workers[0].private_ip} ${aws_instance.instance_workers[1].private_ip}",
      "sudo -H -u kafka /home/kafka/resources_00_tmp/scripts/setup_grafana.sh"
    ]
  }
}



resource "null_resource" "run_me_always_restart_services_master" {
  count = var.master_node_count
  depends_on = [null_resource.run_me_always_workers]
  triggers = {
    always_run = timestamp()
  }

  connection {
    host        = aws_instance.instance_master[count.index].public_ip
    type        = "ssh"
    port        = 22
    user        = "ubuntu"
    private_key = file("${var.pem_file}")
    timeout     = "2m"
    agent       = false
  }

  provisioner "remote-exec" {

    inline = [
      "sudo systemctl stop kafka",
      "sudo systemctl start kafka"
    ]
  }
}




