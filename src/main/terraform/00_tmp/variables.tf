variable "aws_region" {
  type = string
}


variable "ami_image" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "sg_unsecure" {
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

