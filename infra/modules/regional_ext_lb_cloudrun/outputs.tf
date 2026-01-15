output "ip_address" {
  value = google_compute_address.lb_ip.address
}

output "http_forwarding_rule" {
  value = google_compute_forwarding_rule.fr_http.name
}

output "https_forwarding_rule" {
  value = var.enable_https ? google_compute_forwarding_rule.fr_https[0].name : null
}

output "dns_auth_record_name" {
  value = var.enable_https ? google_certificate_manager_dns_authorization.dns_auth[0].dns_resource_record[0].name : null
}

output "dns_auth_record_type" {
  value = var.enable_https ? google_certificate_manager_dns_authorization.dns_auth[0].dns_resource_record[0].type : null
}

output "dns_auth_record_data" {
  value = var.enable_https ? google_certificate_manager_dns_authorization.dns_auth[0].dns_resource_record[0].data : null
}
