output "my_vpc_id_01" {
  value = module.vpc_01.my_vpc_id
}

output "allow_all_ingress_ports_id_01" {
  value = module.vpc_01.allow_all_ingress_ports_id
}

output "subnets_ids_01" {
  value = module.vpc_01.subnets_ids
}

output "my_vpc_id_02" {
  value = module.vpc_02.my_vpc_id
}

output "allow_all_ingress_ports_id_02" {
  value = module.vpc_02.allow_all_ingress_ports_id
}

output "subnets_ids_02" {
  value = module.vpc_02.subnets_ids
}