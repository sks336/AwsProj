resource "aws_instance" "my_instance_1" {
  ami           = var.ami_image
  instance_type = var.instance_type
  subnet_id = aws_subnet.sub_public_1a.id
  key_name = var.key_pair_name
  associate_public_ip_address = "true"
  vpc_security_group_ids = [aws_security_group.basic-ports.id]
}

resource "aws_instance" "my_instance_2" {
  ami           = var.ami_image
  instance_type = var.instance_type
  subnet_id = aws_subnet.sub_private_1b.id
  key_name = var.key_pair_name
  security_groups = [aws_security_group.basic-ports.id]
}