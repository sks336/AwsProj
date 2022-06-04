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

module "vpc_01" {
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

module "vpc_02" {
  source = "../modules/vpc_base"
  vpc_cidr = var.vpc_cidr2
  subnets_azs = var.subnets_azs
  subnets_cidr = var.subnets_cidr2
  subnets_visibility = var.subnets_visibility
  allow_all_ingress_ports = var.allow_all_ingress_ports
  deploy_nat_enabled = var.deploy_nat_enabled
  deploy_vgw_enabled = var.deploy_vgw_enabled
  deploy_igw_enabled = var.deploy_igw_enabled
  deploy_tgw_enabled = var.deploy_tgw_enabled
}

resource "aws_vpc_peering_connection" "vpc_peering_conn" {
  vpc_id        = module.vpc_01.my_vpc_id
  peer_vpc_id   = module.vpc_02.my_vpc_id
  auto_accept   = true

  tags = {
    Name = "VPC Peering between vpc_01 and vpc_02"
  }
}


resource "aws_route" "vpc_01_to_vpc_02" {
  route_table_id = module.vpc_01.rt_with_nat
  destination_cidr_block = var.vpc_cidr2
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering_conn.id
}


resource "aws_route" "vpc_02_to_vpc_01" {
  route_table_id = module.vpc_02.rt_with_nat
  destination_cidr_block = var.vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering_conn.id
}



module "aws_instances_vpc_01" {
  count = 2
  source = "../modules/ec2"
  instance_az = var.subnets_azs[count.index]
  num_instances = 1
  instances_per_azs = [1, 1] # NOT USED
  ami_image           = var.ami_image
  instance_type = var.instance_type
  key_pair_name = var.key_pair_name
  subnets_ids_map = module.vpc_01.subnets_ids_map
  vpc_security_group_ids = module.vpc_01.allow_all_ingress_ports_id
}

module "aws_instances_vpc_02" {
  count = 2
  source = "../modules/ec2"
  instance_az = var.subnets_azs[count.index]
  num_instances = 1
  instances_per_azs = [1, 1] # NOT USED
  ami_image           = var.ami_image
  instance_type = var.instance_type
  key_pair_name = var.key_pair_name
  subnets_ids_map = module.vpc_02.subnets_ids_map
  vpc_security_group_ids = module.vpc_02.allow_all_ingress_ports_id
}
