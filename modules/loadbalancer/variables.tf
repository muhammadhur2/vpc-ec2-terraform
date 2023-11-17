variable "alb_properties" {
  description = "Application Load Balancer Configuration"
  type = object({
    internal = bool
  })
}



variable "target_group_properties" {
  description = "Load Balancer Target Group Configuration"
  type = object({
    port     = number
    protocol = string
    health_check = object({
      healthy_threshold   = string
      interval            = string
      protocol            = string
      matcher             = string
      timeout             = string
      path                = string
      unhealthy_threshold = string
    })
  })
}

variable "vpc_id" {}

variable "subnet_public" {
  type = list(string)
}


variable "app_name" {
  description = "Application name"
  type        = string
}

variable "environment_name" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
}

variable "main_load_balancer_sg_ingress" {
  description = "Ingress rules for load balancer security group"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
    description = string
  }))
}

variable "main_load_balancer_sg_egress" {
  description = "Egress rules for load balancer security group"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}


variable "listeners" {
  description = "Listeners Configuration"
  type = list(object({
    port     = number
    protocol = string
  }))
  default = [
    {
      port     = 80,
      protocol = "HTTP"
    },
    {
      port     = 443,
      protocol = "HTTPS"
    }
  ]
}

variable "ecs_service_names" {
  description = "Names of the ECS services"
  type        = list(string)
}

variable "ecs_service_properties" {
  description = "Properties for ECS services"
  
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