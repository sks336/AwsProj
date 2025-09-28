terraform {
  backend "s3" {
    bucket         = "sach-infra-tf-state"
    key            = "02_kube/terraform.tfstate"
    region         = "ap-southeast-1"
    encrypt        = true
  }
}
