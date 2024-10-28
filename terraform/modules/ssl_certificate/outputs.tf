# more immediately available, but can't be used to securely attach the SSL cert to other resources, mainly for quick cert identification reference and not so useful otherwise
output "unvalidated_arn" {
  value = aws_acm_certificate.cert.arn
}

# gets delayed availability, but CAN be used to securely attach the SSL cert to other resources, use this instead of unvalidated_arn if unsure which to use
output "validated_arn" {
  value = aws_acm_certificate_validation.cert_validation.certificate_arn
}

#DNS Validation Records
output "id" {
  value = "idk" # will decide on this later
}