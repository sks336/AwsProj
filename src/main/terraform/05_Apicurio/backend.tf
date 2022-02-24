terraform {
  backend "s3" {
    bucket         = "sach-infra-tf-state"
    key            = "05_apicurio/terraform.tfstate"
    region         = "ap-southeast-1"
    encrypt        = true
  }
}