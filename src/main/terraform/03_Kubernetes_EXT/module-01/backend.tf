terraform {
  backend "s3" {
    bucket         = "sach-infra-tf-state"
    key            = "03_kubernetes_EXT/module_01/terraform.tfstate"
    region         = "ap-southeast-1"
    encrypt        = true
  }
}