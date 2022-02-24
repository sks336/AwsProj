provider "aws" {
  region = var.region
}

data "terraform_remote_state" "setup-elb" {
  backend = "s3"
  config = {
    bucket = "${var.bucket-name}"
    region = "${var.region}"
    key = "${var.tfstate-path-setup-elb}"
  }
}

resource "aws_route53_record" "kube" {
  allow_overwrite = true
  name            = var.cname_kube
  ttl             = 3600
  type            = "CNAME"
  zone_id         = var.hosted_zone_id

  records = [ data.terraform_remote_state.setup-elb.outputs.alb-dns-name ]
}
