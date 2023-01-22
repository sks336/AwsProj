variable "ami_image" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "key_pair_name" {
  type = string
}

variable "subnets_az" {
  type = string
}
variable "instances_per_azs" {
  type = list(number)
}

variable "num_instances" {
  type = number
}

variable "subnets_ids_map" {
  type = map
}

variable "vpc_security_group_ids" {
  type = list(string)
}


variable "vpc_id" {
  type = string
}
#variable "instance_prefix" {
#  type = string
#}