# ------------------  CREATE IGW

resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
  count = var.deploy_igw_enabled ? 1 : 0
  tags = {
    Name = "my_igw"
  }
}

# ------------------  CREATE VGW
resource "aws_vpn_gateway" "my_vgw" {
  vpc_id = aws_vpc.my_vpc.id
  count = var.deploy_vgw_enabled ? 1 : 0
  tags = {
    Name = "my_vgw"
  }
}

# ------------------  CREATE NGW

resource "aws_eip" "nat_eip" {
  count = var.deploy_nat_enabled ? 1 : 0
  vpc      = true
  tags = {
    Name = "my_nat_eip"
  }
}

resource "aws_nat_gateway" "my_nat" {
  count = var.deploy_nat_enabled ? 1 : 0
  allocation_id = aws_eip.nat_eip[0].id
  subnet_id     = aws_subnet.subnets[0].id # NGW should be in Public Subnet
  tags = {
    Name = "my_nat_gw"
  }
}

# ------------------  CREATE TGW

resource "aws_ec2_transit_gateway" "my_tgw" {
  count = var.deploy_tgw_enabled ? 1 : 0
  description = "Transit Gateway Desc"
  tags = {
    Name = "my_tgw"
  }
}