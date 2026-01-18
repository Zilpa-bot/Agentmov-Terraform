resource "google_certificate_manager_dns_authorization" "prod_apex" {
  name     = "agentmov-prod-auth"
  location = var.region
  domain   = "agentmov.com"
}

resource "google_certificate_manager_dns_authorization" "prod_www" {
  name     = "agentmov-prod-www-auth"
  location = var.region
  domain   = "www.agentmov.com"
}

resource "google_certificate_manager_certificate" "prod_cert" {
  name     = "agentmov-prod-cert"
  location = var.region

  managed {
    domains = ["agentmov.com", "www.agentmov.com"]
    dns_authorizations = [
      google_certificate_manager_dns_authorization.prod_apex.id,
      google_certificate_manager_dns_authorization.prod_www.id,
    ]
  }
}

resource "google_dns_record_set" "prod_apex_auth_cname" {
  managed_zone = google_dns_managed_zone.agentmov_com.name
  name         = google_certificate_manager_dns_authorization.prod_apex.dns_resource_record[0].name
  type         = google_certificate_manager_dns_authorization.prod_apex.dns_resource_record[0].type
  ttl          = 300
  rrdatas      = [google_certificate_manager_dns_authorization.prod_apex.dns_resource_record[0].data]
}

resource "google_dns_record_set" "prod_www_auth_cname" {
  managed_zone = google_dns_managed_zone.agentmov_com.name
  name         = google_certificate_manager_dns_authorization.prod_www.dns_resource_record[0].name
  type         = google_certificate_manager_dns_authorization.prod_www.dns_resource_record[0].type
  ttl          = 300
  rrdatas      = [google_certificate_manager_dns_authorization.prod_www.dns_resource_record[0].data]
}
