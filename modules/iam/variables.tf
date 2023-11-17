variable "iam_policy_properties" {
  description = "IAM Policy Configuration"
  type = object({
    policy_arn = string
  })
}


variable "app_name" {
  description = "Application name"
  type        = string
}

variable "environment_name" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
}