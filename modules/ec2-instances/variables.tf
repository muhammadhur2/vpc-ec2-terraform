variable "app_name" {
  description = "Application name"
  type        = string
}

variable "environment_name" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
}

variable "vpc_id" {}

variable "subnet_public" {
  type = list(string)
}

variable "instances" {
  description = "Map of instance configurations"
  type = map(object({
    ami_id        = string
    instance_type = string
    subnet_index  = number
    sg_ingress    = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    }))
    sg_egress = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    }))
  }))
}
