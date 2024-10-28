# TODO: Add logging support.
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution#logging_config
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_realtime_log_config
resource "aws_cloudfront_distribution" "distribution" {
  enabled         = true
  is_ipv6_enabled = true
  aliases         = [var.cdn_domain_name]
  price_class     = "PriceClass_100" # North America + Europe only.

  origin {
    domain_name = var.bucket_dns_name
    origin_id   = var.bucket_origin_id
  }

  # Cache static assets for 10 minutes by default.
  default_cache_behavior {
    target_origin_id           = var.bucket_origin_id
    allowed_methods            = ["GET", "HEAD", "OPTIONS"]
    cached_methods             = ["GET", "HEAD"]
    viewer_protocol_policy     = "https-only"
    compress                   = false
    cache_policy_id            = aws_cloudfront_cache_policy.cache_policy.id
    response_headers_policy_id = aws_cloudfront_response_headers_policy.response_headers_policy.id
    origin_request_policy_id   = aws_cloudfront_origin_request_policy.origin_policy.id
  }

  # Cache rarely-changed resource assets for 1 day by default.
  ordered_cache_behavior {
    path_pattern               = "/${var.cdn_path_prefix}resources/*"
    target_origin_id           = var.bucket_origin_id
    allowed_methods            = ["GET", "HEAD", "OPTIONS"]
    cached_methods             = ["GET", "HEAD"]
    viewer_protocol_policy     = "https-only"
    compress                   = true
    cache_policy_id            = aws_cloudfront_cache_policy.cache_policy_resources.id
    response_headers_policy_id = aws_cloudfront_response_headers_policy.response_headers_policy.id
    origin_request_policy_id   = aws_cloudfront_origin_request_policy.origin_policy.id
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = var.certificate_arn
    ssl_support_method  = "sni-only"
  }

  logging_config {
    include_cookies = false
    bucket          = aws_s3_bucket.cdn_log_bucket.bucket_domain_name
    prefix          = "cloudfront-logs/"
  }

  depends_on = [
    aws_s3_bucket_ownership_controls.s3_ownership_controls,
    aws_s3_bucket.cdn_log_bucket,
    aws_s3_bucket_public_access_block.cdn_s3_public_access_block,
    aws_s3_bucket_acl.cdn_log_bucket_acl,
  ]
}

# TODO: set up top-level or root terraform.tfvars config for this
resource "aws_s3_bucket" "cdn_log_bucket" {
  bucket = "duelyst-cdn-log-bucket"

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_ownership_controls" "s3_ownership_controls" {
  bucket = aws_s3_bucket.cdn_log_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "cdn_s3_public_access_block" {
  bucket = aws_s3_bucket.cdn_log_bucket.id

  block_public_acls       = false
  block_public_policy     = true
  ignore_public_acls      = false
  restrict_public_buckets = true

#block_public_access {
#    block_public_acls   = false
#    ignore_public_acls  = false
#    block_public_policy = true
#    restrict_public_buckets = true
#  }
}

resource "aws_s3_bucket_acl" "cdn_log_bucket_acl" {
  bucket = aws_s3_bucket.cdn_log_bucket.id
  acl    = "log-delivery-write"

  depends_on = [
    aws_s3_bucket_ownership_controls.s3_ownership_controls,
    aws_s3_bucket.cdn_log_bucket,
    aws_s3_bucket_public_access_block.cdn_s3_public_access_block,
  ]
}
