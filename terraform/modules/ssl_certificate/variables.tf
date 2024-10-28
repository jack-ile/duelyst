variable "domain_name" {
  type        = string
  description = "The domain name for which to create an SSL certificate."
}

variable "route53_zone_id" {
  type        = string
  description = "Zone ID of the Route 53 database storing routing records."
}