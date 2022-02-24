output "alb_name" {
  value = data.terraform_remote_state.setup-elb.outputs.alb-dns-name
}