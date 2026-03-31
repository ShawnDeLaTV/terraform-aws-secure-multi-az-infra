output "vpc_id" {
  value = aws_vpc.main-vpc.id
}
output "public-subnet-a-id" {
  value = aws_subnet.public-subnet-a.id
}
output "public-subnet-b-id" {
  value = aws_subnet.public-subnet-b.id
}
output "private-subnet-a-id" {
  value = aws_subnet.private-subnet-a.id
}
output "private-subnet-b-id" {
  value = aws_subnet.private-subnet-b.id
}