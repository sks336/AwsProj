provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "tmp-instance" {
  ami           = var.ami_image
  instance_type = var.instance_type
  key_name = "sachin-aws-kp2"

  tags = {
    usecase = "testing-${var.aws_region}"
  }
}


resource "null_resource" "run_me_always" {
  depends_on = [aws_instance.tmp-instance]
  triggers = {
    always_run = timestamp()
  }

  provisioner "file" {
    source      = "resources_00_tmp"
    destination = "/tmp"
    connection {
      host        = aws_instance.tmp-instance.public_ip
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
      "sh /home/sachin/scripts/run_nginx.sh"
    ]
    connection {
      host        = aws_instance.tmp-instance.public_ip
      type        = "ssh"
      port        = 22
      user        = "centos"
      private_key = "${file("/Users/sachin/work/keys/aws/sachin-aws-kp3.pem")}"
      timeout     = "2m"
      agent       = false
    }

  }
}



