resource "aws_vpc" "vpc" {
  cidr_block = var.cidr_block

tags = {
  Name = "es_vpc"
  }
}

resource "aws_subnet" "subnet" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.subnet
  map_public_ip_on_launch = "true"
  
tags = {
  Name = "es_subnet"
 }
}

resource "aws_internet_gateway" "gateway" {
  vpc_id     = aws_vpc.vpc.id
tags = {
  Name = "es_gw"
 }
}

resource "aws_default_route_table" "route_table" {
  default_route_table_id = aws_vpc.vpc.default_route_table_id
route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway.id
  }
tags = {
    Name = "es_route_table"
  }

}

resource "aws_security_group" "es_sg" {
  name            = "es_sg"
  description     = "For es server"
  vpc_id          = aws_vpc.vpc.id #Default VPC id here

    ingress { #ES Port
            from_port       = 9200
            to_port         = 9200
            protocol        = "tcp"
           cidr_blocks     = ["0.0.0.0/0"]
        }

    ingress { #SSH Port
            from_port       = 22
            to_port         = 22
            protocol        = "tcp"
            cidr_blocks     = ["0.0.0.0/0"]
        }

    egress {
           from_port = 0
           to_port = 0
           protocol = "-1"
           cidr_blocks = ["0.0.0.0/0"]
        }

      
    tags = {
          Name            = "es-sg"
        }
}

 
output "subnet_id" {
  value = aws_subnet.subnet.id
 }

output "sg_id" {
  value = aws_security_group.es_sg.id
 }
