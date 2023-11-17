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

variable "vpc_id" {}

variable "subnet_db" {
  type = list(string)
}

variable "vpc_sec_grp" {
  type = list(string)
}

variable "public_access" {}

variable "app_name" {
  description = "Application name"
  type        = string
}

variable "environment_name" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
}
