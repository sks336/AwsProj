variable "aws_region" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "ami_image" {
  type = string
}
variable "key_pair_name" {
  type = string
}

variable "allow_all_cidr" {
  type = string
  default = "0.0.0.0/0"
}

variable "vpc_cidr" {
  type = string
}

variable "sub_public_1a_cidr" {
  type = string
}

variable "sub_private_1b_cidr" {
  type = string
}

variable "sub_private_1c_cidr" {
  type = string
}

variable "allowed_ingress_ports" {
  type = list(number)
  default = [22]
}