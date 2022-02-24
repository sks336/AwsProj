output "kube-master-public-ip" {
  value = data.terraform_remote_state.infra.outputs.kube-master-public-ip
}
