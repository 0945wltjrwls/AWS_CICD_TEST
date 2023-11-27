terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.61.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}


# VPC 생성
resource "aws_vpc" "MyVPC" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"
  tags = {
    Name = "MyVPC"
  }
}
# Internet Gateway 생성
resource "aws_internet_gateway" "GW" {
  vpc_id = aws_vpc.MyVPC.id
  tags = {
    Name = "GW"
  }
}
# Elastic Ip 주소 할당
resource "aws_eip" "NAT_EIP" {
  vpc = true
  tags ={
    Name = "NAT_EIP"
  }
}
# NAT Gateway 생성 – EIP 주소 연결
resource "aws_nat_gateway" "MyNATGW" {
  allocation_id = aws_eip.NAT_EIP.id
  subnet_id = aws_subnet.PublicSubnetB1.id
  tags = {
    Name = "MyNATGW"
  }
  depends_on = [aws_internet_gateway.GW]
}


#################### PUBLIC ####################
# VPC PublicSubnet A1, B1
resource "aws_subnet" "PublicSubnetA1" {
  vpc_id = aws_vpc.MyVPC.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-2a"
  tags = {
    Name = "PublicSubnetA1"
  }
}
resource "aws_subnet" "PublicSubnetB1" {
  vpc_id = aws_vpc.MyVPC.id
  cidr_block = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-2b"
  tags = {
    Name = "PublicSubnetB1"
  }
}
# PublicRT1
resource "aws_route_table" "PublicRT" {
  vpc_id = aws_vpc.MyVPC.id
  tags = {
    Name = "PublicRT"
  }
}
#Assocication PublicSubnetA1 + PublicRT1
resource "aws_route_table_association" "public_RT_association1" {
  subnet_id = aws_subnet.PublicSubnetA1.id
  route_table_id = aws_route_table.PublicRT.id
}
#Assocication PublicSubnetB1 + PublicRT2
resource "aws_route_table_association" "Public_RT_Association2" {
  subnet_id = aws_subnet.PublicSubnetB1.id
  route_table_id = aws_route_table.PublicRT.id
}




# VPC PrivateSubnet A2, B2
resource "aws_subnet" "PrivateSubnetA2" {
  vpc_id = aws_vpc.MyVPC.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-east-2a"
  tags = {
    Name = "PrivateSubnetA2" 
  }
}
resource "aws_subnet" "PrivateSubnetB2" {
  vpc_id = aws_vpc.MyVPC.id
  cidr_block = "10.0.5.0/24"
  availability_zone ="us-east-2b"
  tags = {
    Name = "PrivateSubnetB2"
  }
}
# PrivateRT1
resource "aws_route_table" "PrivateRT" {
  vpc_id = aws_vpc.MyVPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.MyNATGW.id
  }
  tags = {
    Name = "PrivateRT"
  }
}
#Assocication PrtivateSubnetA2 + PrivateRT1
resource "aws_route_table_association" "Private_RT_Association1" {
  subnet_id = aws_subnet.PrivateSubnetA2.id
  route_table_id = aws_route_table.PrivateRT.id
}
#Assocication PrivateSubnetB2 +PrivateRT1
resource "aws_route_table_association" "Private_RT_Association2" {
  subnet_id = aws_subnet.PrivateSubnetB2.id
  route_table_id = aws_route_table.PrivateRT.id
}

