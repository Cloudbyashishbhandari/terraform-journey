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

import {
  to = module.web_server["web1"].aws_instance.server
  id = "i-0d2545b061cc9633b"
}
import {
  to = module.web_server["web2"].aws_instance.server
  id = "i-0a62e799f892aecbb"
}


module "web_server" {
  source = "./modules/web_server"

  for_each = {
    web1 = {
      ami           = "ami-0aba19e56f3eaec05"
      instance_type = "t3.micro"
      name          = "Web Server 1"
    }

    web2 = {
      ami           = "ami-0aba19e56f3eaec05"
      instance_type = "t3.micro"
      name          = "Web Server 2"
    }

    
  }

  ami           = each.value.ami
  instance_type = each.value.instance_type
  name          = each.value.name
}