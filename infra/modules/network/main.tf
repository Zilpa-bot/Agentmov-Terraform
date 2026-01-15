terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_compute_network" "vpc" {
  name                    = "${var.name}-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "app" {
  name          = "${var.name}-app-${var.region}"
  region        = var.region
  network       = google_compute_network.vpc.id
  ip_cidr_range = var.app_subnet_cidr

  private_ip_google_access = true
}

resource "google_compute_subnetwork" "proxy_only" {
  name          = "${var.name}-proxy-only-${var.region}"
  region        = var.region
  network       = google_compute_network.vpc.id
  ip_cidr_range = var.proxy_only_subnet_cidr

  purpose = "REGIONAL_MANAGED_PROXY"
  role    = "ACTIVE"
}

resource "google_compute_subnetwork" "svpc_connector" {
  name          = "${var.name}-svpc-conn-${var.region}"
  region        = var.region
  network       = google_compute_network.vpc.id
  ip_cidr_range = var.svpc_connector_cidr

  private_ip_google_access = true
}

resource "google_compute_global_address" "psa_range" {
  name          = "google-managed-services-${google_compute_network.vpc.name}"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = var.psa_prefix_length
  network       = google_compute_network.vpc.id
}

resource "google_service_networking_connection" "psa_connection" {
  network                 = google_compute_network.vpc.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.psa_range.name]
}
