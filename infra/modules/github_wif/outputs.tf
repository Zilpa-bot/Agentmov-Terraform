output "pool_id" {
  value = google_iam_workload_identity_pool.pool.workload_identity_pool_id
}

output "provider_id" {
  value = google_iam_workload_identity_pool_provider.provider.workload_identity_pool_provider_id
}

output "provider_name" {
  value = google_iam_workload_identity_pool_provider.provider.name
}
