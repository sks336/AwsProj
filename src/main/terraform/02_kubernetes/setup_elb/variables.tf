# --------------------------------------------------------------------------------
variable "region" {
  type = string
  default = "ap-southeast-1"
}

variable "bucket-name" {
  type = string
  default = "sach-infra-tf-state"
}

variable "tfstate-path-infra" {
  type = string
  default = "02_kubernetes/infra/terraform.tfstate"
}
# --------------------------------------------------------------------------------