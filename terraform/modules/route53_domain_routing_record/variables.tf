variable "route53_zone_id" {
  type        = string
  description = "Zone ID of the Route 53 database storing routing records."
}

variable "target_domain_name" {
  type        = string
  description = "Domain or subdomain name to record exposure to outside internet traffic."
}

#variable "alias_targets" {
#  type        = list
#  description = "a list of IP addresses or domain names to have this routing record be an alias towards"
#}

variable "alias_domain_name" {
  type        = string
  description = "Domain name to record rerouting towards internally."
}

variable "alias_zone_id" {
  type        = string
  description = "Zone ID of the AWS resource to route internet traffic towards."
}
