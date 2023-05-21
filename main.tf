#vpc
resource "aws_vpc" "demo" {
  cidr_block           = var.cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = "true"

  tags = {
    Name = var.envname
  }
}

#public subnet
resource "aws_subnet" "pubsubnets" {
  count                   = length(var.azs)
  vpc_id                  = aws_vpc.demo.id
  cidr_block              = element(var.pubsubnets, count.index)
  availability_zone       = element(var.azs, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.envname}-pubsubnet-${count.index + 1}"
  }
}

#private subnet
resource "aws_subnet" "privsubnets" {
  count             = length(var.azs)
  vpc_id            = aws_vpc.demo.id
  cidr_block        = element(var.privsubnets, count.index)
  availability_zone = element(var.azs, count.index)


  tags = {
    Name = "${var.envname}-privatesub-${count.index + 1}"
  }
}

#datasubnet
resource "aws_subnet" "datasubnets" {
  count             = length(var.azs)
  vpc_id            = aws_vpc.demo.id
  cidr_block        = element(var.datasubnets, count.index)
  availability_zone = element(var.azs, count.index)


  tags = {
    Name = "${var.envname}-datasubnet-${count.index + 1}"
  }
}

#Internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.demo.id

  tags = {
    Name = "${var.envname}-igw"
  }
}

#Natgatewy elastic ip
resource "aws_eip" "nateip" {

  vpc = true

  tags = {
    Name = "${var.envname}-nateip"
  }
}

#nate gateway
resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.nateip.id
  subnet_id     = aws_subnet.pubsubnets[0].id

  tags = {
    Name = "${var.envname}-natgw"
  }
}

#public route
resource "aws_route_table" "publicroute" {
  vpc_id = aws_vpc.demo.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "${var.envname}-publicroute"
  }

}
#private route

resource "aws_route_table" "privateroute" {
  vpc_id = aws_vpc.demo.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgw.id
  }
  tags = {
    Name = "${var.envname}-privateroute"
  }

}

#data route

resource "aws_route_table" "dataroute" {
  vpc_id = aws_vpc.demo.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgw.id
  }
  tags = {
    Name = "${var.envname}-dataroute"
  }

}

#route table association

resource "aws_route_table_association" "pubsub-association" {
  count          = length(var.pubsubnets)
  subnet_id      = element(aws_subnet.pubsubnets.*.id, count.index)
  route_table_id = aws_route_table.publicroute.id
}


resource "aws_route_table_association" "privsub-association" {
  count          = length(var.privsubnets)
  subnet_id      = element(aws_subnet.privsubnets.*.id, count.index)
  route_table_id = aws_route_table.privateroute.id
}

resource "aws_route_table_association" "datasub-association" {
  count          = length(var.datasubnets)
  subnet_id      = element(aws_subnet.datasubnets.*.id, count.index)
  route_table_id = aws_route_table.dataroute.id
}