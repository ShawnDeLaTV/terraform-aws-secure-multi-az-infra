/*
output "instance_ids" {
  description = "Liste des IDs des instances EC2"
  //value       = aws_instance.example[*].id
  value = concat(aws_instance.example[*].id, aws_instance.exampleB[*].id)
}
*/

