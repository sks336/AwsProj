provider "aws" {
  region = var.aws_region
}

data "aws_security_group" "unsecure" {
  id = var.sg_unsecure
}

# ----------------------------------------------------

resource "aws_instance" "instance_master" {
  count         = var.master_node_count
  ami           = var.ami_image
  instance_type = var.instance_type
  key_name = "sachin-kp"
  vpc_security_group_ids = [data.aws_security_group.unsecure.id]

  tags = {
    usecase = "testing-${var.aws_region}"
  }
}

resource "aws_instance" "instance_workers" {
  depends_on = [aws_instance.instance_master]
  count         = var.worker_nodes_count
  ami           = var.ami_image
  instance_type = var.instance_type
  key_name = "sachin-kp"
  vpc_security_group_ids = [data.aws_security_group.unsecure.id]

  tags = {
    usecase = "testing-${var.aws_region}"
  }
}


resource "null_resource" "run_me_always_master" {
  count = var.master_node_count
  depends_on = [aws_instance.instance_master]
  triggers = {
    always_run = timestamp()
  }

  connection {
    host        = aws_instance.instance_master[count.index].public_ip
    type        = "ssh"
    port        = 22
    user        = "ubuntu"
    private_key = "${file("/Users/sachin/work/keys/aws/sjlearning_2024/sachin-kp.pem")}"
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
      "sudo -H -u sachin /tmp/resources_00_tmp/init.sh ${count.index+1} 1@${aws_instance.instance_master[0].private_ip}:9097,2@${aws_instance.instance_workers[0].private_ip}:9097,3@${aws_instance.instance_workers[1].private_ip}:9097 PLAINTEXT://${aws_instance.instance_master[0].public_ip}:9092 ${aws_instance.instance_master[0].private_ip}"
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
    private_key = "${file("/Users/sachin/work/keys/aws/sjlearning_2024/sachin-kp.pem")}"
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
      "sudo -H -u sachin /tmp/resources_00_tmp/init.sh ${count.index+2} 1@${aws_instance.instance_master[0].private_ip}:9097,2@${aws_instance.instance_workers[0].private_ip}:9097,3@${aws_instance.instance_workers[1].private_ip}:9097 PLAINTEXT://${aws_instance.instance_master[0].public_ip}:9092 ${aws_instance.instance_master[0].private_ip}"
    ]
  }
}


