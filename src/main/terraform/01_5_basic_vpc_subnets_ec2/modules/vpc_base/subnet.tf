resource "aws_subnet" "subnets" {
  count = length(var.subnets_azs)
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = var.subnets_cidr[count.index]
  availability_zone = var.subnets_azs[count.index]
  tags = {
    Name = "my-sub-${var.subnets_visibility[count.index]}-${split("-", var.subnets_azs[count.index])[2]}"
    Type = var.subnets_visibility[count.index]
  }
}