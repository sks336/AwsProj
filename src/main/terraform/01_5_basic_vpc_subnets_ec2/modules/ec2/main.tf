resource "aws_instance" "my_instances" {
  count = var.num_instances
  ami           = var.ami_image
  instance_type = var.instance_type
  subnet_id = var.subnets_ids_map[var.instance_az]
  key_name = var.key_pair_name
  associate_public_ip_address = "true"
  vpc_security_group_ids = var.vpc_security_group_ids
  tags = {
    Name = "inst-${split("-", var.instance_az)[2]}-${count.index}"
  }
}
