resource "google_dns_managed_zone" "agentmov_com" {
  name       = "agentmov-com"
  dns_name   = "agentmov.com."
  visibility = "public"
}
