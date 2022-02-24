provider "aws" {
  region = var.region
}

data "terraform_remote_state" "infra" {
  backend = "s3"
  config = {
    bucket = "${var.bucket-name}"
    region = "${var.region}"
    key = "${var.tfstate-path-infra}"
  }
}


resource "null_resource" "kube_ext_03_copy_resources" {

  provisioner "file" {
    source      = "remote_resources_03_kube_ext"
    destination = "/home/centos"
    connection {
      host        = data.terraform_remote_state.infra.outputs.kube-master-public-ip
      type        = "ssh"
      port        = 22
      user        = "centos"
      private_key = "${file("/Users/sachin/work/aws/sachin-aws-kp.pem")}"
      timeout     = "2m"
      agent       = false
    }
  }
}

resource "null_resource" "kube_ext_03_execute" {
  depends_on = [null_resource.kube_ext_03_copy_resources]
  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/centos/remote_resources_03_kube_ext/*.sh",
      "/bin/sh -c /home/centos/remote_resources_03_kube_ext/run.sh"
    ]
    connection {
      host        = data.terraform_remote_state.infra.outputs.kube-master-public-ip
      type        = "ssh"
      port        = 22
      user        = "centos"
      private_key = "${file("/Users/sachin/work/aws/sachin-aws-kp.pem")}"
      timeout     = "2m"
      agent       = false
    }

  }
}

#data "external" "kube-ingress-port" {
#  program = ["/bin/sh", "-c", "remote_resources/external_datasource_for_ingress_service_port.sh"]
#}


