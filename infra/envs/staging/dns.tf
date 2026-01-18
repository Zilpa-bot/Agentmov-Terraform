resource "google_dns_managed_zone" "stg_agentmov_com" {
  name       = "stg-agentmov-com"
  dns_name   = "stg.agentmov.com."
  visibility = "public"
}

resource "google_dns_record_set" "stg_apex_a" {
  managed_zone = google_dns_managed_zone.stg_agentmov_com.name
  name         = "stg.agentmov.com."
  type         = "A"
  ttl          = 300
  rrdatas      = [module.stg_regional_lb.ip_address]
}

resource "google_dns_record_set" "stg_cert_auth" {
  managed_zone = google_dns_managed_zone.stg_agentmov_com.name
  name         = module.stg_regional_lb.dns_auth_record_name
  type         = module.stg_regional_lb.dns_auth_record_type
  ttl          = 300
  rrdatas      = [module.stg_regional_lb.dns_auth_record_data]
}

output "stg_name_servers" {
  value = google_dns_managed_zone.stg_agentmov_com.name_servers
}
