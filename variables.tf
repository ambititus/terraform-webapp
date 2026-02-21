




variable "instance_type" {
  type = string
}


variable "environment" {
  type = string

}


variable "aws_region" {
  description = "AWS region"
  type        = string
}


variable "availability_zone" {
  description = "Availability Zone for the public subnet"
  type        = string

}


variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}


variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
}


variable "route_cidr_block" {
  description = "route block for the public subnet"
  type        = string

}