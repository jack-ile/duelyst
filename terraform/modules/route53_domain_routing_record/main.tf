resource "aws_route53_record" "routing_record" {
  zone_id = var.route53_zone_id
  name    = var.target_domain_name
  type    = "CNAME" # changed from "A" record for correct DNS redirection behavior
# type    = "A"
  ttl     = 600
  records = [var.alias_domain_name]
#  records = var.alias_targets
  
#  alias {
#    name                   = var.alias_domain_name
#    zone_id                = var.alias_zone_id
#    evaluate_target_health = false
#  }
}