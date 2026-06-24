terraform {
    required_version = ">=1.0.0"
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 5.0"
    }
    
  }
}
resource "aws_instance" "remort-backend" {
    ami = "ami-023b6eace47afd3b4"
    instance_type = "t3.micro" 
}
resource "aws_s3_bucket" "backend-storage" {
    bucket = "ashish4570073"

  
}
resource "aws_dynamodb_table" "example" {
  name         = "terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}