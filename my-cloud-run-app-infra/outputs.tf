output "project_id" {
  description = "The GCP project ID Terraform is configured to use."
  value       = var.project_id
}

output "region" {
  description = "The GCP region Terraform is configured to use."
  value       = var.region
}

output "lb_ip_address" {
  description = "The IP address of the regional external HTTP Load Balancer."
  value       = google_compute_region_address.lb_static_ip.address
}


