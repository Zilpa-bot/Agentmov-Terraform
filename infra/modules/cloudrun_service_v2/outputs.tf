output "service_name" {
  value = google_cloud_run_v2_service.this.name
}

output "service_id" {
  value = google_cloud_run_v2_service.this.id
}
