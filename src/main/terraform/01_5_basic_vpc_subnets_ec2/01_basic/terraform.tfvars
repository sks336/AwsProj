aws_region = "ap-southeast-1"
vpc_cidr = "12.0.0.0/16"
subnets_azs = ["ap-southeast-1a","ap-southeast-1b", "ap-southeast-1c"]
subnets_cidr = ["12.0.0.0/24","12.0.1.0/24","12.0.2.0/24"]
subnets_visibility = ["public","private","private"] # For now, the value "public" has to be at the first index.
allow_all_ingress_ports = [22, 80, 443, 8080]
bucket_name = "sach-infra-tf-state"
deploy_nat_enabled=true # Need more code changes to make it work for false condition
deploy_igw_enabled=true
deploy_vgw_enabled=false
deploy_tgw_enabled=false