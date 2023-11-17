output "target_group_arn" {
  value = aws_lb_target_group.main_targetgroup[*].arn
}

output "load_balancer_security_group_id" {
  description = "ID of the load balancer security group"
  value       = aws_security_group.main_load_balancer_sg.id
}

output "listener_arn" {
  description = "ARNs of the listeners"
  value       = values(aws_lb_listener.listener)[*].arn
}
