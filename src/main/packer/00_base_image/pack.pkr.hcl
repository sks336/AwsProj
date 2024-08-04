packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "base-centos" {
  ami_name      = "00-super-base-image"
  instance_type = "t2.medium"
  region        = "ap-southeast-1"
  source_ami_filter {
    filters = {
      image-id            = "ami-060e277c0d4cce553"
#      root-device-type    = "ebs"
#      virtualization-type = "hvm"
    }
    most_recent = true
#    owners      = ["aws-marketplace"]
    owners      = ["amazon"]
  }
  ssh_username = "ubuntu"
}

build {
  name    = "base-image-packer"
  sources = ["source.amazon-ebs.base-centos"]

  provisioner "file" {
    source = "remote_resources"
    destination = "/tmp/remote_resources"
  }
  provisioner "shell" {
    script = "entry-point.sh"
    pause_before = "3s"
  }
}


