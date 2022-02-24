output kube-master-public-ip {
  value = aws_instance.kube-master.public_ip
}

output kube-master-id {
  value = aws_instance.kube-master.id
}

output "ingress-port" {
  value = data.external.kube-ingress-port.result["ingress_port"]
}