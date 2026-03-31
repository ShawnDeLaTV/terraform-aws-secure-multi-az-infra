output "target_group_arn" {
  description = "ARN of the target group for the load balancer"
  value       = aws_lb_target_group.web-server-target-group.arn
}