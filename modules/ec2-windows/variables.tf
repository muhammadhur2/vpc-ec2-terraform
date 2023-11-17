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

variable "instance_type" {
  description = "The instance type of the EC2 instance."
  type        = string
}

variable "ami_id" {
  description = "The AMI ID of the Windows Server 2016 instance."
  type        = string
}

variable "main_windows_sg_ingress" {
  description = "Ingress rules for windows security group"
  type = list(object({
    from_port = number
    to_port   = number
    protocol  = string
  }))
}

variable "main_windows_sg_egress" {
  description = "Egress rules for windows security group"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}