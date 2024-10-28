output "api_target_group_arn" {
  value = aws_lb_target_group.api_target_group.arn
}

output "game_target_group_arn" {
  value = aws_lb_target_group.game_target_group.arn
}

output "sp_target_group_arn" {
  value = aws_lb_target_group.sp_target_group.arn
}

output "load_balancer_id" {
  value = aws_lb.lb.arn_suffix
}

# Used in Cloudwatch alarms.
output "http_target_group_ids" {
  value = {
    api = aws_lb_target_group.api_target_group.arn_suffix
  }
}

# Used in Cloudwatch alarms.
output "all_target_group_ids" {
  value = {
    api  = aws_lb_target_group.api_target_group.arn_suffix
    game = aws_lb_target_group.game_target_group.arn_suffix
    sp   = aws_lb_target_group.sp_target_group.arn_suffix
  }
}

# Temporary until I can find a better DNS routing setting 
output "load_balancer_domain_name" {
  value = aws_lb.lb.dns_name
}

# Temporary until I can find a better DNS routing setting 
output "load_balancer_zone_id" {
  value = aws_lb.lb.zone_id
}

#output "routing_record_id" {
#  value = "idk" # deciding what to put here later
#}