data "aws_route53_zone" "fancapp" {
  name = "fancapp.com."
}

# TODO: stg.fancapp.comをCloudFrontまたはS3に向けるためのレコードを設定する
# resource "aws_route53_record" "stg_alb" {
#   zone_id = data.aws_route53_zone.fancapp.zone_id
#   name    = "stg.fancapp.com"
#   type    = "A"
#
#   alias {
#     # TODO: ここにS3またはCloudFrontのエンドポイントを指定
#     name                   = "YOUR_CLOUDFRONT_OR_S3_ENDPOINT_HERE"
#     # TODO: 適切なZone IDを指定
#     zone_id                = "YOUR_ZONE_ID_HERE"
#     evaluate_target_health = false
#   }
# }

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
