allowed_ingress_ports=[22, 8443, 9990]
ami_img="ami-0265a419743ca46fd"
allowed_ip_ranges = ["0.0.0.0/0"]
aws_region="ap-southeast-1"
instance_type="t2.medium"
root_block_device_volume_size_in_GB=32
root_block_device_volume_type="gp2"

tfstate_bucket_name = "sach-infra-tf-state"
tfstate_path_infra = "02_kubernetes/infra/terraform.tfstate"
hosted_zone_id="Z02887502WC0RDEJTOJFZ"