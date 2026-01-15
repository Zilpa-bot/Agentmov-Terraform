resource "google_compute_address" "lb_ip" {
  project = var.project_id
  name    = "${var.name}-lb-ip"
  region  = var.region
}

resource "google_compute_region_network_endpoint_group" "srvneg" {
  project               = var.project_id
  name                  = "${var.name}-srvneg"
  region                = var.region
  network_endpoint_type = "SERVERLESS"

  cloud_run {
    service = var.cloud_run_service_name
  }
}

resource "google_compute_region_security_policy" "stg_allowlist" {
  count   = var.enable_armor ? 1 : 0
  project = var.project_id
  name    = "${var.name}-armor-allowlist"
  region  = var.region
  type    = "CLOUD_ARMOR"
}

resource "google_compute_region_security_policy_rule" "allow" {
  count           = var.enable_armor ? 1 : 0
  project         = var.project_id
  region          = var.region
  security_policy = google_compute_region_security_policy.stg_allowlist[0].name
  priority        = 1000
  action          = "allow"

  match {
    versioned_expr = "SRC_IPS_V1"
    config {
      src_ip_ranges = var.allow_cidrs
    }
  }

  description = "Allowlisted IP ranges for staging"
}

resource "google_compute_region_security_policy_rule" "deny_all" {
  count           = var.enable_armor ? 1 : 0
  project         = var.project_id
  region          = var.region
  security_policy = google_compute_region_security_policy.stg_allowlist[0].name
  priority        = 2147483647
  action          = "deny(403)"

  match {
    versioned_expr = "SRC_IPS_V1"
    config {
      src_ip_ranges = ["*"]
    }
  }

  description = "Default deny"
}

resource "google_compute_region_backend_service" "backend" {
  project               = var.project_id
  name                  = "${var.name}-backend"
  region                = var.region
  load_balancing_scheme = "EXTERNAL_MANAGED"
  protocol              = "HTTP"

  backend {
    group           = google_compute_region_network_endpoint_group.srvneg.id
    capacity_scaler = 1.0
  }
}

resource "google_compute_region_url_map" "urlmap" {
  project = var.project_id
  name    = "${var.name}-urlmap"
  region  = var.region

  default_service = google_compute_region_backend_service.backend.self_link
}

resource "google_compute_region_url_map" "http_redirect" {
  count   = var.enable_https ? 1 : 0
  project = var.project_id
  name    = "${var.name}-http-redirect"
  region  = var.region

  default_url_redirect {
    https_redirect         = true
    redirect_response_code = "MOVED_PERMANENTLY_DEFAULT"
    strip_query            = false
  }
}

resource "google_compute_region_target_http_proxy" "http_proxy" {
  project = var.project_id
  name    = "${var.name}-http-proxy"
  region  = var.region

  url_map = var.enable_https ? google_compute_region_url_map.http_redirect[0].self_link : google_compute_region_url_map.urlmap.self_link
}

resource "google_compute_forwarding_rule" "fr_http" {
  project               = var.project_id
  name                  = "${var.name}-fr-http"
  region                = var.region
  load_balancing_scheme = "EXTERNAL_MANAGED"
  ip_protocol           = "TCP"
  port_range            = "80"
  target                = google_compute_region_target_http_proxy.http_proxy.self_link
  ip_address            = google_compute_address.lb_ip.address
}

resource "google_certificate_manager_dns_authorization" "dns_auth" {
  count       = var.enable_https ? 1 : 0
  project     = var.project_id
  name        = "${var.name}-dns-auth"
  location    = var.region
  type        = "PER_PROJECT_RECORD"
  domain      = var.domain
  description = "DNS authorization for ${var.domain}"
}

resource "google_certificate_manager_certificate" "managed_cert" {
  count       = var.enable_https ? 1 : 0
  project     = var.project_id
  name        = "${var.name}-managed-cert"
  location    = var.region
  description = "Google-managed cert for ${var.domain}"

  managed {
    domains            = [var.domain]
    dns_authorizations = [google_certificate_manager_dns_authorization.dns_auth[0].id]
  }
}

resource "google_compute_region_ssl_policy" "tls12_modern" {
  count           = var.enable_https ? 1 : 0
  project         = var.project_id
  name            = "${var.name}-tls12-modern"
  region          = var.region
  profile         = "MODERN"
  min_tls_version = "TLS_1_2"
  description     = "Enforce TLS1.2+ for ${var.name}"
}

resource "google_compute_region_target_https_proxy" "https_proxy" {
  count   = var.enable_https ? 1 : 0
  project = var.project_id
  name    = "${var.name}-https-proxy"
  region  = var.region
  url_map = google_compute_region_url_map.urlmap.self_link

  certificate_manager_certificates = [
    google_certificate_manager_certificate.managed_cert[0].id
  ]

  ssl_policy = google_compute_region_ssl_policy.tls12_modern[0].id
}

resource "google_compute_forwarding_rule" "fr_https" {
  count                 = var.enable_https ? 1 : 0
  project               = var.project_id
  name                  = "${var.name}-fr-443"
  region                = var.region
  load_balancing_scheme = "EXTERNAL_MANAGED"
  port_range            = "443"
  ip_address            = google_compute_address.lb_ip.address
  target                = google_compute_region_target_https_proxy.https_proxy[0].id
}
