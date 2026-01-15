module "network" {
  source     = "../../modules/network"
  project_id = var.project_id
  region     = var.region
  name       = "agentmov-stg"

  app_subnet_cidr        = "10.10.0.0/24"
  proxy_only_subnet_cidr = "10.10.8.0/23"
  svpc_connector_cidr    = "10.10.4.0/28"

  psa_prefix_length = 16
}

module "vpc_connector" {
  source     = "../../modules/vpc_connector"
  project_id = var.project_id
  region     = var.region

  name        = "agentmov-stg-vpc-conn"
  network     = module.network.vpc_self_link
  subnet_name = module.network.serverless_connector_subnet_name
}

module "artifact_registry" {
  source     = "../../modules/artifact_registry"
  project_id = var.project_id
  region     = var.region

  repository_id = "agentmov"
  description   = "Agentmov container images"
}

resource "google_artifact_registry_repository_iam_member" "gateway_runtime_reader" {
  project    = var.project_id
  location   = module.artifact_registry.location
  repository = module.artifact_registry.repository_id
  role       = "roles/artifactregistry.reader"
  member     = "serviceAccount:${var.gateway_service_account_email}"
}

module "stg_regional_lb" {
  source = "../../modules/regional_ext_lb_cloudrun"

  project_id = var.project_id
  region     = var.region

  name                   = "agentmov-stg"
  cloud_run_service_name = "agentmov-gateway"

  allow_cidrs  = var.stg_allow_cidrs
  enable_armor = false
  enable_https = true
  domain       = var.stg_domain

  depends_on = [google_compute_subnetwork.default_proxy_only]
}

data "google_compute_network" "default" {
  project = var.project_id
  name    = "default"
}

resource "google_compute_subnetwork" "default_proxy_only" {
  project       = var.project_id
  region        = var.region
  name          = "agentmov-stg-proxy-only-default-${var.region}"
  ip_cidr_range = "192.168.100.0/23"
  network       = data.google_compute_network.default.self_link
  purpose       = "REGIONAL_MANAGED_PROXY"
  role          = "ACTIVE"
}
