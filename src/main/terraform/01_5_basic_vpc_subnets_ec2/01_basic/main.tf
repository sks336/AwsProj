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