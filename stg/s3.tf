resource "aws_s3_bucket" "fanc_s3_bucket_stg" {
  bucket = "fanc-bucket-stg"

  website {
    index_document = "index.html"
    error_document = "index.html"
  }

  tags = {
    Environment = "stg"
  }
}

resource "aws_s3_bucket_versioning" "fanc_s3_bucket_versioning_stg" {
  bucket = aws_s3_bucket.fanc_s3_bucket_stg.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_policy" "fanc_s3_bucket_policy_stg" {
  bucket = aws_s3_bucket.fanc_s3_bucket_stg.bucket

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject",
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "arn:aws:s3:::fanc-bucket-stg/*"
      }
    ]
  })
}

resource "aws_s3_bucket_public_access_block" "fanc_s3_bucket_public_access_block_stg" {
  bucket = aws_s3_bucket.fanc_s3_bucket_stg.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
