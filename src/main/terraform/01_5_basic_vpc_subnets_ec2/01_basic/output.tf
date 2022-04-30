output "my_vpc_id" {
  value = module.base_infra.my_vpc_id
}

output "allow_all_ingress_ports_id" {
  value = module.base_infra.allow_all_ingress_ports_id
}

#output "subnets_ids_map" {
#  value = module.base_infra.subnets_ids_map
#}