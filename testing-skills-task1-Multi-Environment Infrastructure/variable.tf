variable "vpc_cidr_range" {
  description = "cidr renge of the vpc"

}
variable "subnet_cidr_range" {
  description = "cidr range of the subnet"

}
variable "route_table_cidr_range" {
  description = "cidr range of the route table"

}
variable "ami_id" {
  description = "ami id of the user"


}
variable "instance_type" {
  description = "instance type of the different env"
  type        = map(string)
  default = {
    "dev"   = "t3.micro"
    "stage" = "t3.medium"
    "prod"  = "t3.xlarge"
  }

}
variable "env" {
  description = "environment of the application"



}
variable "owner" {
  description = "owner of the project"


}
variable "project" {
  description = "type of project"


}