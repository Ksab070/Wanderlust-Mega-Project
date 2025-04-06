#Main vpc for deployment
resource "aws_vpc" "main-vpc" {
  cidr_block           = "10.0.0.0/16"
  tags                 = local.aws_tags
  enable_dns_hostnames = true
}

#Subnet 1
resource "aws_subnet" "j-subnet" {
  vpc_id                                      = aws_vpc.main-vpc.id
  cidr_block                                  = "10.0.1.0/24"
  enable_resource_name_dns_a_record_on_launch = true
  map_public_ip_on_launch = true
  availability_zone                           = local.subnet_az1
  tags                                        = merge(local.aws_tags, {
    "kubernetes.io/role/elb" = "1"
    "kubernetes.io/cluster/wanderlust" = "owned"
  })

}

#Subnet 2
resource "aws_subnet" "j-subnet2" {
  vpc_id                                      = aws_vpc.main-vpc.id
  cidr_block                                  = "10.0.2.0/24"
  enable_resource_name_dns_a_record_on_launch = true
  map_public_ip_on_launch = true
  availability_zone                           = local.subnet_az2
  tags                                        = merge(local.aws_tags, {
    "kubernetes.io/role/elb" = "1"
    "kubernetes.io/cluster/wanderlust" = "owned"
  })
}


#Security group for jenkins vpc
resource "aws_security_group" "j-security-group" {
  name   = "jenkins-sec-group"
  vpc_id = aws_vpc.main-vpc.id
  tags   = local.aws_tags
}

#Egress allowed to anywhere
resource "aws_vpc_security_group_egress_rule" "j-egress" {
  security_group_id = aws_security_group.j-security-group.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = -1
}

#Ingress for SSH from anywhere
resource "aws_vpc_security_group_ingress_rule" "j-ingress-1" {
  security_group_id = aws_security_group.j-security-group.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
}

#Ingress for Port 80
resource "aws_vpc_security_group_ingress_rule" "j-ingress-2" {
  security_group_id = aws_security_group.j-security-group.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}

#Port 8080
resource "aws_vpc_security_group_ingress_rule" "j-ingress-3" {
  security_group_id = aws_security_group.j-security-group.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 8080
  to_port           = 8080
  ip_protocol       = "tcp"
}

#Port 443
resource "aws_vpc_security_group_ingress_rule" "j-ingress-4" {
  security_group_id = aws_security_group.j-security-group.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
}

#Port 465 smtps 
resource "aws_vpc_security_group_ingress_rule" "j-ingress-5" {
  security_group_id = aws_security_group.j-security-group.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 465
  to_port           = 465
  ip_protocol       = "tcp"
}

#Port 25 for smtp
resource "aws_vpc_security_group_ingress_rule" "j-ingress-6" {
  security_group_id = aws_security_group.j-security-group.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 25
  to_port           = 25
  ip_protocol       = "tcp"
}

#Port 6379 for redis
resource "aws_vpc_security_group_ingress_rule" "j-ingress-7" {
  security_group_id = aws_security_group.j-security-group.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 6379
  to_port           = 6379
  ip_protocol       = "tcp"
}

#Port 6443 for Kubernetes api server port
resource "aws_vpc_security_group_ingress_rule" "j-ingress-8" {
  security_group_id = aws_security_group.j-security-group.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 6443
  to_port           = 6443
  ip_protocol       = "tcp"
}

#Port 30000 - 32767 Kubernetes node ports
resource "aws_vpc_security_group_ingress_rule" "j-ingress-9" {
  security_group_id = aws_security_group.j-security-group.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 30000
  to_port           = 32767
  ip_protocol       = "tcp"
}

#Port 3000 - 10000 other app ports
resource "aws_vpc_security_group_ingress_rule" "j-ingress-10" {
  security_group_id = aws_security_group.j-security-group.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 3000
  to_port           = 10000
  ip_protocol       = "tcp"
}

#Internet gateway for the VPC
resource "aws_internet_gateway" "j-igw" {
  vpc_id = aws_vpc.main-vpc.id
  tags   = local.aws_tags
}

# Route table
resource "aws_route_table" "j-routetable" {
  vpc_id = aws_vpc.main-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.j-igw.id
  }

  route {
    cidr_block = "10.0.0.0/16"
    gateway_id = "local"
  }

  tags = local.aws_tags
}

#Route table - Subnet association 
resource "aws_route_table_association" "subnet-association" {
  subnet_id      = aws_subnet.j-subnet.id
  route_table_id = aws_route_table.j-routetable.id
}

resource "aws_route_table_association" "subnet-association2" {
  subnet_id      = aws_subnet.j-subnet2.id
  route_table_id = aws_route_table.j-routetable.id
}

