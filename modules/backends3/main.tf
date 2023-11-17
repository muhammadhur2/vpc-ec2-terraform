resource "aws_s3_bucket" "main_s3_bucket" {
  bucket = "rahuma-terraform-state"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "main_s3_bucket_encryption" {
  bucket = aws_s3_bucket.main_s3_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "main_s3_bucket_lifecycle" {
  bucket = aws_s3_bucket.main_s3_bucket.id

  rule {
    id = "rule-1"

    filter {}

    status = "Enabled"
  }
}


resource "aws_s3_bucket_versioning" "main_s3_bucket_versioning" {
  bucket = aws_s3_bucket.main_s3_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}


resource "aws_dynamodb_table" "main_dynamodb" {
  name         = "terraform-state-locking"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}