#output "ipv4" {
#  value= aws_instance.tmp-instance[0].public_ip, aws_instance.tmp-instance[1].public_ip, aws_instance.tmp-instance[2].public_ip
#}


locals {
  publicIPs = [aws_instance.instance_master[0].public_ip, aws_instance.instance_workers[0].public_ip, aws_instance.instance_workers[1].public_ip]
  privateIPs = [aws_instance.instance_master[0].private_ip, aws_instance.instance_workers[0].private_ip, aws_instance.instance_workers[1].private_ip]
}



output "publicIps" {
  value= "${join(", ", local.publicIPs)}"
}

output "privateIps" {
  value= "${join(", ", local.privateIPs)}"
}
