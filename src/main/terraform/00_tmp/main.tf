provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "tmp-instance" {
  ami           = lookup(var.ami_images_regional, var.aws_region)
  instance_type = var.instance_type
  key_name = "sachin-aws-kp"

  provisioner "file" {
    source      = "resources_00_tmp"
    destination = "/tmp"
    connection {
      host        = coalesce(self.public_ip, self.private_ip)
      type        = "ssh"
      port        = 22
      user        = "centos"
      private_key = "${file("~/work/aws/sachin-aws-kp.pem")}"
      timeout     = "2m"
      agent       = false
    }
  }

  tags = {
    usecase = "testing-${var.aws_region}"
  }
}



