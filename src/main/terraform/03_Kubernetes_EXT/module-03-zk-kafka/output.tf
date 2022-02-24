output "kube_master_ip" {
  value = data.terraform_remote_state.infra.outputs.kube-master-public-ip
}
