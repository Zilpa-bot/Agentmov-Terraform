resource "google_dns_record_set" "prod_apex_a" {
  count        = var.prod_lb_ip != "" ? 1 : 0
  managed_zone = google_dns_managed_zone.agentmov_com.name
  name         = "agentmov.com."
  type         = "A"
  ttl          = 300
  rrdatas      = [var.prod_lb_ip]
}

resource "google_dns_record_set" "prod_www_cname" {
  managed_zone = google_dns_managed_zone.agentmov_com.name
  name         = "www.agentmov.com."
  type         = "CNAME"
  ttl          = 300
  rrdatas      = ["agentmov.com."]
}
