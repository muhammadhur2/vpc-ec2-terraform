output "ecs_service_names" {
  value = [for s in aws_ecs_service.main_ecs_service : s.name]
}
