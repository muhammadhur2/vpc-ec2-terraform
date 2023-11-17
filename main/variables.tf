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
  default     = ["us-east-1a", "us-east-1b"]
}


variable "sse_algorithm" {
  type = string
}


variable "s3_frontend_public_block_properties" {
  description = "S3 Bucket Public Access Block Configuration"
  type = object({
    block_public_acls       = bool
    block_public_policy     = bool
    ignore_public_acls      = bool
    restrict_public_buckets = bool
  })
}

variable "cloudfront_distribution_properties" {
  description = "CloudFront Distribution Configuration"
  type = object({
    cache_policy_id        = string
    allowed_methods        = list(string)
    cached_methods         = list(string)
    viewer_protocol_policy = string
    error_caching_min_ttl  = number
    error_code             = number
    response_code          = number
    response_page_path     = string
    geo_restriction_type   = string
    locations              = list(string)
  })
}


variable "db_properties" {
  description = "Subnets Configuration"
  type = map(object({
    allocated_storage   = number
    instance_class      = string
    engine              = string
    username            = string
    password            = string
    skip_final_snapshot = bool

  }))
  default = {
    "db1" = { allocated_storage = 30, instance_class = "db.t3.micro", engine = "postgres", username = "dbadmin", password = "Rahnumadb123!", skip_final_snapshot = true }
  }
}

variable "public_access" {}


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

variable "iam_policy_properties" {
  description = "IAM Policy Configuration"
  type = object({
    policy_arn = string
  })
}

variable "main_securitygroup_ingress" {
  description = "Ingress rules for main security group"
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}

variable "main_securitygroup_egress" {
  description = "Egress rules for main security group"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
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







// starting here again

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