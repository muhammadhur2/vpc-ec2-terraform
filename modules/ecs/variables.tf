variable "ecs_task_definition_properties" {
  description = "ECS Task Definition Configuration"
  type = object({
    network_mode             = string
    cpu                      = string
    memory                   = string
    execution_role_arn       = string
    requires_compatibilities = list(string)
    container_image          = string
    container_cpu            = number
    container_memory         = number
    container_port           = number
    host_port                = number
    log_group                = string
    log_region               = string
    log_stream_prefix        = string
  })
}

variable "ecs_cluster_properties" {
  description = "ECS Cluster Configuration"
  type = object({
    container_insights = string
  })
}

variable "ecs_service_properties" {
  description = "ECS Service Configuration"
  type = list(object({
    launch_type          = string
    desired_count        = number
    force_new_deployment = bool
    assign_public_ip     = bool
    container_name       = string
    container_port       = number
    path_pattern         = string
  }))
}



variable "vpc_id" {}

variable "subnet_public" {
  type = list(string)
}

variable "target_group_arn" {
  description = "ARN of the target group"
  type        = list(string)
}

variable "load_balancer_security_group_id" {
  description = "ID of the load balancer security group"
  type        = string
}

variable "listener_arn" {
  description = "ARNs of the listeners"
  type        = list(string)
}

variable "ecs_task_execution_role_arn" {
  description = "ARN of the ECS Task Execution Role"
  type        = string
}

variable "app_name" {
  description = "Application name"
  type        = string
}

variable "environment_name" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
}


variable "main_container_sg_ingress" {
  description = "Ingress rules for container security group"
  type = list(object({
    from_port = number
    to_port   = number
    protocol  = string
  }))
}

variable "main_container_sg_egress" {
  description = "Egress rules for container security group"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}


variable "database_url" {
  description = "Database URL for the application"
  type        = string
}
