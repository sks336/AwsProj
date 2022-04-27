variable "vpc_cidr" {
  type = string
}
variable "allow_all_cidr" {
  type = string
  default = "0.0.0.0/0"
}

variable "subnets_azs" {
  type = list(string)
}
variable "subnets_cidr" {
  type = list(string)
}

variable "subnets_visibility" {
  type = list(string)
}

variable "allow_all_ingress_ports" {
  type = list(number)
}

variable "deploy_nat_enabled" {
  type = bool
}

variable "deploy_igw_enabled" {
  type = bool
}

variable "deploy_vgw_enabled" {
  type = bool
}


variable "deploy_tgw_enabled" {
  type = bool
}
