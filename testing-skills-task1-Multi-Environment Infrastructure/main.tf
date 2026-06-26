terraform {
  required_version = ">=1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.0"
    }
  }
}
provider "aws" {
  region = "eu-north-1"

}
resource "aws_key_pair" "secrete_key" {
  key_name   = "terraform.key"
  public_key = file("C:/Users/ASHISH BHANDARI/.ssh/id_rsa.pub")

}
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr_range

}
resource "aws_subnet" "sub" {
  cidr_block              = var.subnet_cidr_range
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "eu-north-1a"
  map_public_ip_on_launch = "true"
}
resource "aws_internet_gateway" "network" {
  vpc_id = aws_vpc.vpc.id

}
resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.network.id
  }

}
resource "aws_route_table_association" "name" {
  route_table_id = aws_route_table.rt.id
  subnet_id      = aws_subnet.sub.id

}
resource "aws_security_group" "sg" {
  name   = "web"
  vpc_id = aws_vpc.vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
resource "aws_instance" "name" {
  ami                    = var.ami_id
  instance_type          = lookup(var.instance_type, terraform.workspace, "t3.micro")
  key_name               = aws_key_pair.secrete_key.key_name
  vpc_security_group_ids = [aws_security_group.sg.id]
  subnet_id              = aws_subnet.sub.id
  tags = {
    "environment" = var.env
    "owner"       = var.owner
    "project"     = var.project
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("C:/Users/ASHISH BHANDARI/.ssh/id_rsa")
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'hello from server' ",
      "sudo apt update -y"


    ]

  }
}