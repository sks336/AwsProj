output "my_vpc_id" {
  value = aws_vpc.my_vpc.id
}

output "allow_all_ingress_ports_id" {
  value = [aws_security_group.allow_all_ingress_ports.id]
}

output "subnets_ids_map" {
  value       = "${zipmap(aws_subnet.subnets[*].availability_zone, aws_subnet.subnets[*].id)}"
}

output "rt_with_ig" {
  value = aws_route_table.rt_with_ig.id
}

output "rt_with_nat" {
  value = aws_route_table.rt_with_nat[0].id
}