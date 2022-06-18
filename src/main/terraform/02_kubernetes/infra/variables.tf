# --------------------------------------------------------------------------------
variable "region" {
  type = string
}

variable "ami_image" {
  type = string
}

variable "instance-type" {
  type = string
}

variable n_slaves {
  type = number
}

variable "hosted_zone_id" {
  type = string
}

variable "deploy_route_53" {
  type = bool
  default = false
}

# --------------------------------------------------------------------------------