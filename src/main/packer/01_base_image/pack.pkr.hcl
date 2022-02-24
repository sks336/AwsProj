packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "base-centos" {
  ami_name      = "base-image-aws"
  instance_type = "t2.micro"
  region        = "ap-southeast-1"
  source_ami_filter {
    filters = {
      image-id            = "ami-07f65177cb990d65b"
#      image-id            = "ami-0e8ab9462dd57f73b"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["aws-marketplace"]
  }
  ssh_username = "centos"
}

build {
  name    = "base-image-packer"
  sources = ["source.amazon-ebs.base-centos"]

  provisioner "file" {
    source = "remote_resources"
    destination = "/tmp/remote_resources"
  }
  provisioner "shell" {
    script = "remote_resources/entry-point.sh"
    pause_before = "3s"
  }
}


