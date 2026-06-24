terraform {
    required_version = ">= 1.0.0"

    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 5.0"
        }
    }
}

resource "aws_instance" "example" {
    ami =   var.ami_id
    instance_type = var.instance_type
}