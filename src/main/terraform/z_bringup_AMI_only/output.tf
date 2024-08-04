output "publicIP" {
  value= "${aws_instance.instance.public_ip}"
}