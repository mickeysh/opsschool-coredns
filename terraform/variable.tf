variable "aws_region" {
  default = "us-east-1"
}

variable "default_keypair_name" {
  description = "Name of the KeyPair used for all nodes"
  default = "OpsSchool"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "number_of_server" {
  default = "2"
}

variable "owner" {
  default = "DNS-Class"
}

variable "vpc_id" {
  description = "ID of vpc to create instances in in the format vpc-xxxxxxxx"
  default = "vpc-876ddde1"
}
