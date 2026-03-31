variable "main-vpc-id" {
  description = "ID of the main VPC"
  type        = string
}
variable "alb-sg-id" {
  description = "ID of the ALB security group"
  type        = string
}
variable "public-subnet-a-id"{
    description = "ID of the public subnet A"
    type        = string
}
variable "public-subnet-b-id"{
    description = "ID of the public subnet B"
    type        = string
}