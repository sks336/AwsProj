output "aws_machine_ip" {
  value = aws_instance.ec2_instance.public_ip
}
