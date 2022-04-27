resource "aws_route_table" "rt_with_ig" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = var.allow_all_cidr
    gateway_id = aws_internet_gateway.my_igw[0].id
  }

  tags = {
    Name = "rt_with_ig"
  }
}

resource "aws_route_table" "rt_with_nat" {
  vpc_id = aws_vpc.my_vpc.id
  count = var.deploy_nat_enabled ? 1 : 0

  route {
    cidr_block = var.allow_all_cidr
    gateway_id = aws_nat_gateway.my_nat[0].id
  }

  tags = {
    Name = "rt_with_nat"
  }
}

resource "aws_route_table_association" "rt_with_ig_association" {
  subnet_id      = aws_subnet.subnets[0].id
  route_table_id = aws_route_table.rt_with_ig.id
}

resource "aws_route_table_association" "rt_with_nat_association" {
  count = length(var.subnets_azs) - 1
  subnet_id      = aws_subnet.subnets[count.index + 1].id
  route_table_id = aws_route_table.rt_with_nat[0].id
}