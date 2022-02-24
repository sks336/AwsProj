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
variable "tfstate-path-setup-elb" {
  type = string
  default = "02_kubernetes/setup_elb/terraform.tfstate"
}

variable "hosted_zone_id" {
  type = string
  default = "Z02887502WC0RDEJTOJFZ"
}

variable "cname_kube" {
  type = string
  default = "kube.thesachinshukla.com"
}
# --------------------------------------------------------------------------------