variable "aws_region" {
  type = string
}


variable "ami_image" {
  type = string
}

variable "instance_type" {
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
  default = 2
}

variable "pem_key_name" {
  type = string
}

variable "pem_file" {
  type = string
}

