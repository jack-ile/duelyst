module "staging_load_balancer" {
  source          = "../modules/load_balancer"
  name            = "duelyst-staging"
  vpc_id          = module.internal_vpc.id
  security_groups = [module.load_balancer_security_group.id]
  subnets = [
    module.first_subnet.id,
    module.second_subnet.id,
    module.third_subnet.id,
  ]
  route53_zone_id     = data.aws_route53_zone.route53_zone.zone_id
  certificate_arn     = module.staging_ssl_certificate.validated_arn
  staging_domain_name = var.staging_domain_name
  cdn_domain_name     = var.cdn_domain_name
  cdn_path_prefix     = "staging/"

  api_listen_port   = 443
  api_service_port  = 3000
  game_listen_port  = 8001
  game_service_port = 8001
  sp_listen_port    = 8000
  sp_service_port   = 8000

# record_domain_name = var.staging_domain_name # we need to use the root domain name later, staging and prod domains originate from root domain
}


# !!Implicitly wrapped into "../modules/load_balancer"
#module "domain_name_record" {
#  source = "" # "route53_record"
#  route53_zone_id = aws_route53_zone.route53_zone.zone_id
#  record_domain_name = var.staging_domain_name # we need to use the root domain name later, staging and prod domains originate from root domain
#  lb_dns_name = var.staging_domain_name # may need to use a separate auto-generated DNS name of load balancer instead
#  lb_zone_id = "" # pull from "staging_load_balancer" output or internals
#}


module "staging_ssl_certificate" {
  source          = "../modules/ssl_certificate"
  domain_name     = var.staging_domain_name
  route53_zone_id = data.aws_route53_zone.route53_zone.zone_id
}


# !!Implicitly wrapped into "../modules/ssl_certificate"
# must be created AFTER route 53 records are created
#module "staging_ssl_certificate_validation" {
#  source   = "" # "aws_acm_certificate_validation"
#  cert_arn = module.staging_ssl_certificate.arn
#  #"domain_name_record" dependency variable
#}
