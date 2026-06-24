variable "ami_id" {
    description = "this is th ami id"
  
}
variable "instance_type" {
    description = "this is the instance type "
    type = map(string)
    default = {
      "dev" = "t3.micro"
      "staging" = "t3.medium"
      "prod" = "t3.xlarge"
    }
  
}