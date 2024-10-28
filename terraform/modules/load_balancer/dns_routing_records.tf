#resource "aws_route53_record" "lb_route53_record" {
#  zone_id = var.route53_zone_id
#  name    = var.cdn_domain_name #var.record_domain_name (!!need to assess need to use dedicated root domain name instead, but should at least use Staging domain name instead)
#  type    = "A" # debatably should use CNAME instead
  
#  alias {
#    name                   = aws_lb.lb.dns_name
#    zone_id                = aws_lb.lb.zone_id
#    evaluate_target_health = false
#  }
#}

module "lb_routing_record" {
  source = "../route53_domain_routing_record"
  route53_zone_id = var.route53_zone_id
  target_domain_name = var.staging_domain_name #var.record_domain_name (!!need to assess need to use dedicated root domain name instead, but should at least use Staging domain name instead)
#  alias_targets = [aws_lb.lb.dns_name]
  alias_domain_name = aws_lb.lb.dns_name
  alias_zone_id = aws_lb.lb.zone_id
}