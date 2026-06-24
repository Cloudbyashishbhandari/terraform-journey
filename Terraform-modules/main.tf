provider "aws" {
    region = "eu-north-1"
  
}
module "ec2_instance" {
    source = "./modules/ec2_instance"
    ami_id =   var.ami_id
    instance_type = var.instance_type
  
}