variable "public-subnet-a-id" {
  description = "ID of the public subnet A"
  type        = string
}
variable "private-subnet-a-id" {
  description = "ID of the private subnet A"
  type        = string
}
variable "private-subnet-b-id" {
  description = "ID of the private subnet B"
  type        = string
}
variable "public-subnet-b-id" {
  description = "ID of the public subnet B"
  type        = string
}
variable "web-server-sg-id" {
  description = "ID of the web server security group"
  type        = string
}
variable "target_group_arn" {
  description = "ARN of the target group for the load balancer"
  type        = string
}