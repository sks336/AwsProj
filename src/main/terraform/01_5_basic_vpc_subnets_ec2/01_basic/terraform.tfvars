allow_all_ingress_ports = [22, 80, 443, 8080]
ami_image = "ami-09795ba3720fbb0d0"
aws_region = "ap-southeast-1"
bucket_name = "sach-infra-tf-state"
deploy_nat_enabled=true # Need more code changes to make it work for false condition
deploy_igw_enabled=true
deploy_vgw_enabled=false
deploy_tgw_enabled=false

# If 'create_instances' is true, then only the EC2 instances would be created, else ignored.
create_instances = true

# Define the AZs where instances should be created! (this must be the subset of property 'subnets_azs')
instances_azs = ["ap-southeast-1a","ap-southeast-1b"]

# Define the number of instances that should be created on these azs
instances_per_azs = [1, 2]

instance_type = "t2.micro"
key_pair_name = "sachin-aws-kp2"
subnets_azs = ["ap-southeast-1a","ap-southeast-1b", "ap-southeast-1c"]
subnets_cidr = ["12.0.0.0/24","12.0.1.0/24","12.0.2.0/24"]
subnets_visibility = ["public","private","private"] # For now, the value "public" has to be at the first index.
vpc_cidr = "12.0.0.0/16"