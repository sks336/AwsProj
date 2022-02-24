output "kube-master-id-from-remote-state-file" {
  value = data.terraform_remote_state.infra.outputs.kube-master-id
}

output "kube-master-public-ip" {
  value = data.terraform_remote_state.infra.outputs.kube-master-public-ip
}
output "ingress-port" {
  value = data.external.kube-ingress-port.result["ingress_port"]
}

output "alb-dns-name" {
  value = aws_lb.kube-alb.dns_name
}