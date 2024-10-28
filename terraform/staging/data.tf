# this data fetch operation could be nested inside of "route53_record" module instead (except then the fetch would be repeated for each record resource created)
data "aws_route53_zone" "route53_zone" {
#  name         = "example.com."  # Replace with your domain name. Ensure the trailing dot.
#  name         = "${var.staging_domain_name}." # we need to use the root domain name later, staging and prod domains originate from root domain
  name         = "${var.registered_domain_name}."
  private_zone = false           # Set to true if you're looking for a private hosted zone.
}
