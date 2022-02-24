variable "aws_region" {
  type = string
  default = "ap-southeast-1"
}

variable "allowed_ingress_ports" {
  type = list(number)
  default = [22]
}

variable "allowed_ip_ranges" {
  type = list(string)
}

variable "ami_img" {
  type = string
}

variable "instance_type" {
  type = string
  default = "t2.micro"
}

variable "root_block_device_volume_size_in_GB" {
  type = number
  default = 8
}

variable "root_block_device_volume_type" {
  type = string
  default = "gp2"
}
