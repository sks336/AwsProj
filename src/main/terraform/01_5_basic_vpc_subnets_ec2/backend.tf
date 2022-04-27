terraform {
  backend "s3" {
    bucket         = "sach-infra-tf-state"
    key            = "01_5_basic/terraform.tfstate"
    region         = "ap-southeast-1"
    encrypt        = true
  }
}