variable "aws_region" {
  default = "us-east-1"
}
variable "cidr_block_main_vpc" {
  description = "CIDR block for the main VPC"
  type        = string
}
variable "cidr_block_public_subnet_a" {
  description = "CIDR block for the public subnet A"
  type        = string
}
variable "cidr_block_private_subnet_a" {
  description = "CIDR block for the private subnet A"
  type        = string
}
variable "cidr_block_public_subnet_b" {
  description = "CIDR block for the public subnet B"
  type        = string
}
variable "cidr_block_private_subnet_b" {
  description = "CIDR block for the private subnet B"
  type        = string
}