variable "aws_region" {
  type = string
}

variable "vpc_id" {
  description = "ID of the existing VPC"
  type        = string
}

variable "allowed_ports" {
  default = [80, 443, 9000]
}

variable "subnet_id_a_pub" {
  description = "ID of the existing subnet"
  type        = string
}

variable "subnet_id_a_prv" {
  description = "ID of the existing subnet"
  type        = string
}

variable "subnet_id_b_prv" {
  description = "ID of the existing subnet"
  type        = string
}

variable "role_name_ssm" {
  description = "Name of Instance profile role"
  type = string
}

variable "ip_address_master0" {
  description = "Master machine IP Address"
  type = string
}

variable "ip_address_worker1" {
  description = "Worker-1 machine IP Address"
  type = string
}

variable "ip_address_worker2" {
  description = "Worker-2 machine IP Address"
  type = string
}

# variable "eni_ids" {
#   description = "List of ENI IDs to attach to EC2 instances (master0, worker1, worker2)"
#   type        = list(string)
#   default     = [
#     "eni-05ec0a1b60c37944b",
#     "eni-0f02f970520d7e945",
#     "eni-0694f09f1fd20a09d"
#   ]
# }

locals {
  subnet_ids_prv = [
    var.subnet_id_a_prv,
    var.subnet_id_b_prv
  ]
}



variable "app_port_keycloak" {
  type = number
}

variable "acm_certificate_arn" {
  type = string
}

variable "hosted_zone_id" {
  type = string
}

variable "host_keycloak" {
  type = string
}

variable "host_harbor" {
  type = string
}

variable "host_kafdrop" {
  type = string
}

variable "ami_image" {
  type = string
}

variable "worker_instance_type" {
  type = string
}
variable "master_instance_type" {
  type = string
}


variable "master_node_count" {
  type = number
  default = 1
}

variable "worker_nodes_count" {
  type = number
  default = 1
}

variable "pem_key_name" {
  type = string
}

variable "pem_file" {
  type = string
}

