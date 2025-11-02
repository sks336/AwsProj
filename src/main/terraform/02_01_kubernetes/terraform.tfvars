aws_region="ap-southeast-1"

pem_file = "/tmp/sachin-kp.pem"
pem_key_name = "sachin-kp"

role_name_ssm = "ssm_role"
ip_address_master0= "172.31.40.100"
ip_address_worker1= "172.31.40.101"
ip_address_worker2= "172.31.40.102"


vpc_id = "vpc-04e6e31d5c2b14a2d"
subnet_id_a_pub = "subnet-0ad3ede8a8a31061b"
subnet_id_a_prv = "subnet-0d15ee4f99aced0a4"
subnet_id_b_prv = "subnet-0d15ee4f99aced0a4"


ami_image = "ami-0e7b0a8faa9ada04a"

master_node_count = 0
worker_nodes_count = 2
master_instance_type = "t3.large"
worker_instance_type = "t3.medium"


host_keycloak = "keycloak.techlearning.me"
host_harbor = "harbor.techlearning.me"
host_kafdrop = "kafdrop.techlearning.me"
host_prometheus = "prometheus.techlearning.me"
host_grafana = "grafana.techlearning.me"

hosted_zone_id = "Z0220809O47PS7K1065N"
acm_certificate_arn = "arn:aws:acm:ap-southeast-1:339713188524:certificate/9f7cd8ba-3176-46da-b79e-6fa7df096a5d"
app_port_keycloak=30443

