terraform {
  required_version = ">=1.0.0"
  required_providers {
    aws  = {
        source = "hashicorp/aws"
        version = "~>6.0"
        
    }
  }
}
provider "aws" {
  region = "eu-north-1"
}
resource "aws_instance" "workspace" {
    ami = var.ami_id
    instance_type = var.instance_type
  
}