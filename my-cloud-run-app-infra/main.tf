provider "google" {
  project = var.project_id
  region  = var.region
}

# --- Cloud Run Service Definition ---
resource "google_cloud_run_v2_service" "gateway_service" {
  # The name of your Cloud Run service (e.g., your gateway)
  name     = "agentmov-gateway-staging"
  location = var.region
  project  = var.project_id

  # Set to true for production, false for staging/dev to allow easier deletion
  deletion_protection = false

  # Ingress settings:
  # - INGRESS_TRAFFIC_ALL: Allows external and internal traffic (required for LB exposure)
  # - INGRESS_TRAFFIC_INTERNAL_ONLY: Only allows traffic from within the VPC (e.g., from other services)
  # - INGRESS_TRAFFIC_INTERNAL_LOAD_BALANCER: Only allows traffic from an internal HTTP(S) LB
  ingress = "INGRESS_TRAFFIC_INTERNAL_LOAD_BALANCER"

  template {
    service_account = google_service_account.cloud_run_service_account.email

    containers {
      image = "me-west1-docker.pkg.dev/agentmov-on-cloud/containers/agentmov-gateway:dev"

      # Optional: Define resource limits if necessary
      resources {
        limits = {
          cpu    = "1"     # 1 vCPU
          memory = "512Mi" # 512 MB of memory
        }
      }
    }

    # Optional: Define scaling parameters
    scaling {
      min_instance_count = 0  # Scale to 0 when idle
      max_instance_count = 10 # Maximum instances
    }
  }

  lifecycle {
    precondition {
      condition     = var.environment != "prod" || var.allow_prod_apply
      error_message = "Refusing to apply to prod unless allow_prod_apply=true."
    }
  }
}

# --- Service Account for the Cloud Run Service ---
resource "google_service_account" "cloud_run_service_account" {
  account_id   = "agentmov-gw-sa"
  display_name = "Service Account for Cloud Run Gateway Service"
  project      = var.project_id
}

# --- Regional External HTTP(S) Load Balancer Components ---

# 1. Reserve a Regional Static IP Address for the Load Balancer
resource "google_compute_address" "lb_static_ip" {
  name         = "agentmov-staging-external-ip-regional"
  region       = var.region
  project      = var.project_id
  address_type = "EXTERNAL"
}

# 2. Create a Proxy-Only Subnet (REQUIRED for Regional External HTTP(S) Load Balancers)
resource "google_compute_subnetwork" "proxy_only_subnet" {
  name          = "agentmov-staging-proxy-subnet"
  ip_cidr_range = "10.129.0.0/23"
  purpose       = "REGIONAL_MANAGED_PROXY"
  role          = "ACTIVE"
  network       = "default"
  region        = var.region
  project       = var.project_id
}

# 3. Create a Serverless Network Endpoint Group (NEG)
resource "google_compute_region_network_endpoint_group" "cloud_run_neg" {
  name                  = "agentmov-staging-cr-neg"
  network_endpoint_type = "SERVERLESS"
  region                = var.region
  project               = var.project_id

  cloud_run {
    service = google_cloud_run_v2_service.gateway_service.name
  }
}

# 4. Create a Backend Service for the Cloud Run NEG
resource "google_compute_region_backend_service" "cloud_run_backend" {
  name                  = "agentmov-staging-cr-backend"
  protocol              = "HTTP"
  port_name             = "http"
  timeout_sec           = 30
  load_balancing_scheme = "EXTERNAL_MANAGED"
  region                = var.region
  project               = var.project_id

  backend {
    group = google_compute_region_network_endpoint_group.cloud_run_neg.id
  }

  health_checks = [google_compute_health_check.default_http_health_check.id]

  iap {
    oauth2_client_id     = var.iap_oauth2_client_id
    oauth2_client_secret = var.iap_oauth2_client_secret
  }
}

# 5. Define a Health Check for the Backend Service
resource "google_compute_health_check" "default_http_health_check" {
  name                = "agentmov-staging-http-hc"
  request_path        = "/"
  check_interval_sec  = 5
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 2
  project             = var.project_id

  http_health_check {
    port = 80
  }
}

# 6. Create a Google-Managed SSL Certificate
resource "google_compute_managed_ssl_certificate" "default_ssl_certificate" {
  name    = "agentmov-staging-managed-cert"
  project = var.project_id

  managed {
    domains = [
      "stg.agentmov.com",
      "www.stg.agentmov.com",
    ]
  }
}

# 7. Create a URL Map to direct traffic to the Backend Service
resource "google_compute_region_url_map" "default_url_map" {
  name            = "agentmov-staging-url-map"
  default_service = google_compute_region_backend_service.cloud_run_backend.id
  region          = var.region
  project         = var.project_id
}

# 8. Create a Target HTTPS Proxy (for SSL/TLS termination)
resource "google_compute_region_target_https_proxy" "default_https_proxy" {
  name             = "agentmov-staging-https-proxy"
  url_map          = google_compute_region_url_map.default_url_map.id
  ssl_certificates = [google_compute_managed_ssl_certificate.default_ssl_certificate.id]
  region           = var.region
  project          = var.project_id
}

# 9. Create a Regional Forwarding Rule for HTTPS
resource "google_compute_forwarding_rule" "default_https_frontend" {
  name                  = "agentmov-staging-https-frontend"
  ip_protocol           = "TCP"
  port_range            = "443"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  target                = google_compute_region_target_https_proxy.default_https_proxy.id
  ip_address            = google_compute_address.lb_static_ip.id
  region                = var.region
  project               = var.project_id
}

# 10. Redirect HTTP to HTTPS
resource "google_compute_region_url_map" "http_to_https_redirect_url_map" {
  name   = "agentmov-staging-http-redirect-url-map"
  region = var.region
  project = var.project_id

  default_url_redirect {
    https_redirect         = true
    strip_query            = false
    redirect_response_code = "MOVED_PERMANENTLY_DEFAULT"
  }
}

resource "google_compute_region_target_http_proxy" "http_to_https_redirect_proxy" {
  name    = "agentmov-staging-http-redirect-proxy"
  url_map = google_compute_region_url_map.http_to_https_redirect_url_map.id
  region  = var.region
  project = var.project_id
}

resource "google_compute_forwarding_rule" "http_to_https_redirect_frontend" {
  name                  = "agentmov-staging-http-redirect-frontend"
  ip_protocol           = "TCP"
  port_range            = "80"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  target                = google_compute_region_target_http_proxy.http_to_https_redirect_proxy.id
  ip_address            = google_compute_address.lb_static_ip.id
  region                = var.region
  project               = var.project_id
}

# 11. Firewall Rule for Health Checks and LB Traffic
resource "google_compute_firewall" "allow_lb_traffic" {
  name    = "agentmov-staging-lb-traffic"
  network = "default"
  project = var.project_id

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  source_ranges = ["35.191.0.0/16", "130.211.0.0/22"]
  target_tags   = ["allow-regional-lb"]
}

# 12. IAP access policy for the backend service
resource "google_iap_web_backend_service_iam_binding" "iap_access" {
  project             = var.project_id
  web_backend_service = google_compute_region_backend_service.cloud_run_backend.name
  role                = "roles/iap.httpsResourceAccessor"
  members             = var.iap_members
}

