provider "aws" {
  region = var.aws_region
}

module "base_infra" {
  source = "../modules/vpc_base"
  vpc_cidr = var.vpc_cidr
  subnets_azs = var.subnets_azs
  subnets_cidr = var.subnets_cidr
  subnets_visibility = var.subnets_visibility
  allow_all_ingress_ports = var.allow_all_ingress_ports
  deploy_nat_enabled = var.deploy_nat_enabled
  deploy_vgw_enabled = var.deploy_vgw_enabled
  deploy_igw_enabled = var.deploy_igw_enabled
  deploy_tgw_enabled = var.deploy_tgw_enabled
}


module "aws_instance" {
  count = var.create_instances ? length(var.instances_azs) : 0
  source = "../modules/ec2"
  instance_az = var.instances_azs[count.index]
  num_instances = var.instances_per_azs[count.index]
  instances_per_azs = var.instances_per_azs # NOT USED
  ami_image           = var.ami_image
  instance_type = var.instance_type
  key_pair_name = var.key_pair_name
  subnets_ids_map = module.base_infra.subnets_ids_map
  vpc_security_group_ids = module.base_infra.allow_all_ingress_ports_id
}
