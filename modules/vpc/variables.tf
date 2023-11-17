variable "app_name" {
  description = "Application name"
  type        = string
}

variable "environment_name" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
}

variable "vpc_cidr" {}


variable "subnets-public" {
  description = "Subnets Configuration"
  type = map(object({
    cidr = string
  }))
  default = {
    "subnets-public1" = { cidr = "10.1.0.0/24" },
    "subnets-public2" = { cidr = "10.1.10.0/24" }
  }
}

variable "subnets-private" {
  description = "Subnets Configuration"
  type = map(object({
    cidr = string
  }))
  default = {
    "subnets-private1" = { cidr = "10.1.20.0/24" },
    "subnets-private2" = { cidr = "10.1.30.0/24" }
  }
}

variable "subnets-db" {
  description = "Subnets Configuration"
  type = map(object({
    cidr = string
  }))
  default = {
    "subnets-db1" = { cidr = "10.1.40.0/24" },
    "subnets-db2" = { cidr = "10.1.50.0/24" }
  }
}

variable "availability_zones" {
  description = "Centralized availability zones"
  type        = list(string)
}



variable "main_securitygroup_ingress" {
  description = "Ingress rules for vpc security group"
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}

variable "main_securitygroup_egress" {
  description = "Egress rules for vpc security group"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}