output "vpc_name" {
  value = google_compute_network.vpc.name
}

output "vpc_id" {
  value = google_compute_network.vpc.id
}

output "app_subnet_self_link" {
  value = google_compute_subnetwork.app.self_link
}

output "proxy_only_subnet_self_link" {
  value = google_compute_subnetwork.proxy_only.self_link
}

output "svpc_connector_subnet_self_link" {
  value = google_compute_subnetwork.svpc_connector.self_link
}

output "psa_range_name" {
  value = google_compute_global_address.psa_range.name
}
