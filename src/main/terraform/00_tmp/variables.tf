variable "aws_region" {
  type = string
  default = "ap-southeast-1"
}

variable "ami_images_regional" {
  type = map
  default = {
    ap-southeast-1 = "ami-055d15d9cfddf7bd3"
    us-west-2 = "ami-0892d3c7ee96c0bf7"
  }
}

variable "instance_type" {
  type = string
  default = "t2.micro"
}

