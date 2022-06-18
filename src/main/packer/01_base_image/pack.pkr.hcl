packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "base-centos" {
  ami_name      = "01-base-image-aws"
  instance_type = "t2.medium"
  region        = "ap-southeast-1"
  source_ami_filter {
    filters = {
      image-id            = "ami-0128a2e6ccdd8e088"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["839006695980"]
  }
  ssh_username = "centos"
}

build {
  name    = "base-image-packer"
  sources = ["source.amazon-ebs.base-centos"]

  provisioner "file" {
    source = "remote_resources_01"
    destination = "/tmp/remote_resources_01"
  }
  provisioner "shell" {
    script = "remote_resources_01/entry-point.sh"
    pause_before = "3s"
  }
}


