#resource "aws_route53_record" "cdn_route53_record" {
#  zone_id = var.route53_zone_id
#  name    = var.cdn_domain_name #var.bucket_dns_name or var.app_domain_name could be used instead
#  type    = "A" # debatably should use CNAME instead
#  
#  alias {
#    name                   = aws_cloudfront_distribution.distribution.domain_name
#    zone_id                = aws_cloudfront_distribution.distribution.hosted_zone_id
#    evaluate_target_health = false
#  }
#}

module "cdn_routing_record" {
  source = "../route53_domain_routing_record"
  route53_zone_id = var.route53_zone_id
  target_domain_name = var.cdn_domain_name #var.bucket_dns_name or var.app_domain_name could be used instead
#  alias_targets = [aws_cloudfront_distribution.distribution.domain_name]
  alias_domain_name = aws_cloudfront_distribution.distribution.domain_name
  alias_zone_id = aws_cloudfront_distribution.distribution.hosted_zone_id
}
