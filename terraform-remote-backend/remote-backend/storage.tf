terraform {
  backend "s3" {
    bucket = "ashish4570073"
    key = "terraform.tfstate"
    region = "eu-north-1"
    dynamodb_table = "terraform-locks"
    
  }
}