aws_region="ap-southeast-1"

pem_file = "/tmp/sachin-kp.pem"
pem_key_name = "sachin-kp"

role_name_ssm = "ssm_role"
ip_address_master0= "172.31.40.100"
ip_address_worker1= "172.31.40.101"
ip_address_worker2= "172.31.40.102"


vpc_id = "vpc-04e6e31d5c2b14a2d"
subnet_id_a_prv = "subnet-0d15ee4f99aced0a4"
subnet_id_b_prv = "subnet-0d15ee4f99aced0a4"


ami_image = "ami-0e7b0a8faa9ada04a"

master_node_count = 0
worker_nodes_count = 2
master_instance_type = "t3.xlarge"
worker_instance_type = "t3.xlarge"


