provider "aws" {
  region = var.aws_region
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}


data "terraform_remote_state" "infra" {
  backend = "s3"
  config = {
    bucket = "${var.tfstate_bucket_name}"
    region = "${var.aws_region}"
    key = "${var.tfstate_path_infra}"
  }
}



resource "null_resource" "run_me_always" {
  triggers = {
    always_run = timestamp()
  }

  provisioner "file" {
    source      = "remote_resource_m03_zk_kafka"
    destination = "/tmp"
    connection {
      host        = data.terraform_remote_state.infra.outputs.kube-master-public-ip
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
      "cp -rf /tmp/remote_resource_m03_zk_kafka /home/centos && chmod +x /home/centos/remote_resource_m03_zk_kafka/*.sh",
      "nohup /home/centos/remote_resource_m03_zk_kafka/entrypoint.sh > /tmp/vm_zk_kafka.log 2>&1 &",
      "sleep 10"
    ]
    connection {
      host        = data.terraform_remote_state.infra.outputs.kube-master-public-ip
      type        = "ssh"
      port        = 22
      user        = "centos"
      private_key = "${file("/Users/sachin/work/keys/aws/sachin-aws-kp3.pem")}"
      timeout     = "2m"
      agent       = false
    }
  }
}
