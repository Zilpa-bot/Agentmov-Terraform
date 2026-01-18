resource "google_service_account" "github_deploy_stg" {
  account_id   = "sa-github-deploy-stg"
  display_name = "GitHub Actions deployer (staging)"
}

resource "google_project_iam_member" "github_deploy_stg_run_admin" {
  project = var.project_id
  role    = "roles/run.admin"
  member  = "serviceAccount:${google_service_account.github_deploy_stg.email}"
}

resource "google_service_account_iam_member" "github_deploy_stg_sa_user" {
  service_account_id = "projects/${var.project_id}/serviceAccounts/${var.gateway_service_account_email}"
  role               = "roles/iam.serviceAccountUser"
  member             = "serviceAccount:${google_service_account.github_deploy_stg.email}"
}

resource "google_artifact_registry_repository_iam_member" "github_deploy_stg_ar_writer" {
  project    = var.project_id
  location   = module.artifact_registry.location
  repository = module.artifact_registry.repository_id
  role       = "roles/artifactregistry.writer"
  member     = "serviceAccount:${google_service_account.github_deploy_stg.email}"
}
