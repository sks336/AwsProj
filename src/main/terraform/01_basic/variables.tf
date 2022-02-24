variable "aws_region" {
  type = string
  default = "ap-southeast-1"

}

variable "instance_type" {
  type = string
  default = "t2.micro"
}

variable server_port {
  type = number
  default = 8080
}

variable ssh_port {
  type = number
  default = 22
}

variable "ami_image" {
  type = string
  default = "ami-0a2b605fb9419bc77"
}