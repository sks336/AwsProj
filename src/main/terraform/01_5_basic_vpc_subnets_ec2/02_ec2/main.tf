provider "aws" {
  region = var.aws_region
}

data "terraform_remote_state" "state_01_basic" {
  backend = "s3"
  config = {
    bucket = var.bucket_name
    region = var.aws_region
    key = var.state_01_basic_key
  }
}


module "aws_instance" {
  source = "../modules/ec2"
  num_instances = var.num_instances
  ami_image           = var.ami_image
  instance_type = var.instance_type
  subnet_ids = data.terraform_remote_state.state_01_basic.outputs.subnets_ids
  key_pair_name = var.key_pair_name
  vpc_security_group_ids = [data.terraform_remote_state.state_01_basic.outputs.allow_all_ingress_ports_id]
}
