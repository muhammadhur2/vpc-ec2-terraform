resource "aws_s3_bucket" "main_s3_frontend" {
  bucket = "${var.app_name}-${var.environment_name}-s3bucket"
}


resource "aws_s3_bucket_server_side_encryption_configuration" "main_s3_frontend_encryption" {
  bucket = aws_s3_bucket.main_s3_frontend.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = var.sse_algorithm
    }
  }
}

resource "aws_s3_bucket_public_access_block" "main_s3_frontend_public_block" {
  bucket = aws_s3_bucket.main_s3_frontend.id

  block_public_acls       = var.s3_frontend_public_block_properties.block_public_acls
  block_public_policy     = var.s3_frontend_public_block_properties.block_public_policy
  ignore_public_acls      = var.s3_frontend_public_block_properties.ignore_public_acls
  restrict_public_buckets = var.s3_frontend_public_block_properties.restrict_public_buckets
}


resource "aws_cloudfront_distribution" "main_cloudfront_dist" {
  origin {
    domain_name = aws_s3_bucket.main_s3_frontend.bucket_regional_domain_name
    origin_id   = local.s3_origin_id
  }

  enabled = true



  default_cache_behavior {
    cache_policy_id        = var.cloudfront_distribution_properties.cache_policy_id
    allowed_methods        = var.cloudfront_distribution_properties.allowed_methods
    cached_methods         = var.cloudfront_distribution_properties.cached_methods
    target_origin_id       = local.s3_origin_id
    viewer_protocol_policy = var.cloudfront_distribution_properties.viewer_protocol_policy
    function_association {
      event_type   = "viewer-request"
      function_arn = aws_cloudfront_function.custom_function.arn
    }
  }

  custom_error_response {
    error_caching_min_ttl = var.cloudfront_distribution_properties.error_caching_min_ttl
    error_code            = var.cloudfront_distribution_properties.error_code
    response_code         = var.cloudfront_distribution_properties.response_code
    response_page_path    = var.cloudfront_distribution_properties.response_page_path
  }

  restrictions {
    geo_restriction {
      locations        = var.cloudfront_distribution_properties.locations
      restriction_type = var.cloudfront_distribution_properties.geo_restriction_type
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}


resource "aws_cloudfront_function" "custom_function" {
  name     = "${var.app_name}-${var.environment_name}-function"
  runtime  = "cloudfront-js-1.0"
  comment  = "A custom function"

  code = <<EOT
function handler(event) {
  var request = event.request;
  var uri = request.uri;

  // Check whether the URI is missing a file name.
  if (uri.endsWith('/')) {
    request.uri += 'index.html';
  } 
  // Check whether the URI is missing a file extension.
  else if (!uri.includes('.')) {
    request.uri += '/index.html';
  }

  return request;
}
EOT

  publish = true
}
