terraform {
  required_version = ">=1.0.0"
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~>5.0"
    }
  }
}

resource "aws_vpc" "vpc" {
    cidr_block = var.cidr_value
  
}
resource "aws_subnet" "sub1" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.subnet_cidr
    availability_zone = "eu-north-1a"
    map_public_ip_on_launch = true
  
}
resource "aws_internet_gateway" "ig" {
    vpc_id = aws_vpc.vpc.id
  
}
resource "aws_route_table" "rt" {
    vpc_id = aws_vpc.vpc.id
    route{
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.ig.id
    }
  
}
resource "aws_route_table_association" "rta" {
    subnet_id = aws_subnet.sub1.id
    route_table_id = aws_route_table.rt.id
  
}
resource "aws_security_group" "sg" {
    name = "wed"
    vpc_id = aws_vpc.vpc.id
    ingress{
        description = "HTTP from vpc"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress{
        description = "SSH connection"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]

    }
    egress{
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
      name = "wed-sg" 
    }
}
resource "aws_key_pair" "deployer" {
  key_name   = "terraform-key"
  public_key = file("C:/Users/ASHISH BHANDARI/.ssh/id_rsa.pub")
}
resource "aws_instance" "ec2" {
    ami = "ami-0aba19e56f3eaec05"
    instance_type = "t3.micro"
    key_name = aws_key_pair.deployer.key_name
    vpc_security_group_ids = [aws_security_group.sg.id]
    subnet_id = aws_subnet.sub1.id

    connection {
      type = "ssh"
      user = "ubuntu"
      private_key = file("C:/Users/ASHISH BHANDARI/.ssh/id_rsa")
      host = self.public_ip
    }
    provisioner "file" {
        source = "app.py"
        destination = "/home/ubuntu/app.py"
    }
    provisioner "remote-exec" {
        inline = [ 
            "echo 'hello form the remote server'",
            "sudo apt update -y",
            "sudo apt install python3-pip -y",
            "cd /home/ubuntu",
            "sudo pip3 install flask",
            "sudo python3 app.py & ",
         ]
      
    }
  
}