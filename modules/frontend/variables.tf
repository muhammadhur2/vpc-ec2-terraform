variable "app_name" {
  description = "Application name"
  type        = string
}

variable "environment_name" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
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
