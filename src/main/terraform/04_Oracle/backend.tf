terraform {
  backend "s3" {
    bucket         = "sach-infra-tf-state"
    key            = "04_oracle/terraform.tfstate"
    region         = "ap-southeast-1"
    encrypt        = true
  }
}