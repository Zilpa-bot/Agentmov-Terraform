output "stg_lb_ip" {
  value = module.stg_regional_lb.ip_address
}

output "stg_dns_auth_record_name" {
  value = module.stg_regional_lb.dns_auth_record_name
}

output "stg_dns_auth_record_type" {
  value = module.stg_regional_lb.dns_auth_record_type
}

output "stg_dns_auth_record_data" {
  value = module.stg_regional_lb.dns_auth_record_data
}
