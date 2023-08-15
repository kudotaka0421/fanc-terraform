resource "aws_cloudfront_distribution" "fanc_cloudfront_distribution_stg" {
  enabled             = true
  is_ipv6_enabled     = true
  comment             = "CloudFront Distribution for stg.fancapp.com"
  default_root_object = "index.html"

  # 追加: 代替ドメイン名（CNAME）の設定
  aliases = ["stg.fancapp.com"]

  origin {
    domain_name = "fanc-bucket-stg.s3-website-us-east-1.amazonaws.com"
    origin_id   = "S3-fanc-bucket-stg"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-fanc-bucket-stg"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  viewer_certificate {
    acm_certificate_arn      = "arn:aws:acm:us-east-1:757245745517:certificate/1532a906-f277-4dd3-9a1b-14c1ae07ab8a"
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.1_2016"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  custom_error_response {
    error_code            = 404
    response_code         = 200
    response_page_path    = "/index.html"
    error_caching_min_ttl = 10
  }

  tags = {
    Environment = "stg"
  }
}
