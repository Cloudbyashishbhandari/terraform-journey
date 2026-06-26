terraform {
  required_version = ">=1.0.0"
   required_providers {
     aws = {
        source = "hashicorp/aws"
        version = "~>5.0"
     }
   }
  
}
provider "aws" {
    region = "eu-north-1"
  
}
resource "aws_key_pair" "deployer" {
    key_name = "ec2-login-key" 
    public_key = file("C:/Users/ASHISH BHANDARI/.ssh/id_rsa.pub")

}
resource "aws_security_group" "sg" {
    name = "vault_sg"
    description = "Security group for Vault"
    ingress {
        description = "ssh traffic"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        description = "http traffic"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 8200
        to_port = 8200
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [ "0.0.0.0/0" ]
    }
  
}
resource "aws_instance" "vault_server" {
    ami = var.ami_id
    instance_type = var.instance_type
    key_name = aws_key_pair.deployer.key_name
    vpc_security_group_ids = [ aws_security_group.sg.id ]
    tags = {
        secret = data.vault_kv_secret_v2.example.data["username"]
    }

    connection  {
        type = "ssh"
        user = "ubuntu"
        private_key = file("C:/Users/ASHISH BHANDARI/.ssh/id_rsa")
        host = self.public_ip
    }
    provisioner "remote-exec" {
        inline = [ 
            "sudo apt update && sudo apt install gpg",
            "wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg",
            "gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint",
            "echo \"deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main\" | sudo tee /etc/apt/sources.list.d/hashicorp.list",
            "sudo apt update -y",
            "sudo apt install -y vault",
        ]
      }
    
}