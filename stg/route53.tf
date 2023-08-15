data "aws_route53_zone" "fancapp" {
  name = "fancapp.com."
}

# stg.fancapp.comをCloudFrontに向けるレコード
resource "aws_route53_record" "stg_cloudfront" {
  zone_id = data.aws_route53_zone.fancapp.zone_id
  name    = "stg.fancapp.com"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.fanc_cloudfront_distribution_stg.domain_name
    zone_id                = aws_cloudfront_distribution.fanc_cloudfront_distribution_stg.hosted_zone_id
    evaluate_target_health = false
  }
}

# api.stg.fancapp.comをALBに向けるレコード
resource "aws_route53_record" "stg_api_alb" {
  zone_id = data.aws_route53_zone.fancapp.zone_id
  name    = "api.stg.fancapp.com"
  type    = "A"

  alias {
    name                   = aws_lb.fanc_alb_stg.dns_name
    zone_id                = aws_lb.fanc_alb_stg.zone_id
    evaluate_target_health = false
  }
}
