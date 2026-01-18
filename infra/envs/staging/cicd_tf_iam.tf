resource "google_service_account" "github_tf_stg" {
  account_id   = "sa-github-tf-stg"
  display_name = "GitHub Actions Terraform (staging)"
}

resource "google_project_iam_member" "github_tf_stg_run_admin" {
  project = var.project_id
  role    = "roles/run.admin"
  member  = "serviceAccount:${google_service_account.github_tf_stg.email}"
}

resource "google_project_iam_member" "github_tf_stg_compute_admin" {
  project = var.project_id
  role    = "roles/compute.admin"
  member  = "serviceAccount:${google_service_account.github_tf_stg.email}"
}

resource "google_project_iam_member" "github_tf_stg_cloudsql_admin" {
  project = var.project_id
  role    = "roles/cloudsql.admin"
  member  = "serviceAccount:${google_service_account.github_tf_stg.email}"
}

resource "google_project_iam_member" "github_tf_stg_secretmanager_admin" {
  project = var.project_id
  role    = "roles/secretmanager.admin"
  member  = "serviceAccount:${google_service_account.github_tf_stg.email}"
}

resource "google_project_iam_member" "github_tf_stg_servicenetworking_admin" {
  project = var.project_id
  role    = "roles/servicenetworking.networksAdmin"
  member  = "serviceAccount:${google_service_account.github_tf_stg.email}"
}

resource "google_project_iam_member" "github_tf_stg_vpcaccess_admin" {
  project = var.project_id
  role    = "roles/vpcaccess.admin"
  member  = "serviceAccount:${google_service_account.github_tf_stg.email}"
}

resource "google_project_iam_member" "github_tf_stg_artifactregistry_admin" {
  project = var.project_id
  role    = "roles/artifactregistry.admin"
  member  = "serviceAccount:${google_service_account.github_tf_stg.email}"
}

resource "google_project_iam_member" "github_tf_stg_certmanager_admin" {
  project = var.project_id
  role    = "roles/certificatemanager.editor"
  member  = "serviceAccount:${google_service_account.github_tf_stg.email}"
}

resource "google_project_iam_member" "github_tf_stg_dns_admin" {
  project = var.project_id
  role    = "roles/dns.admin"
  member  = "serviceAccount:${google_service_account.github_tf_stg.email}"
}

resource "google_project_iam_member" "github_tf_stg_iam_sa_admin" {
  project = var.project_id
  role    = "roles/iam.serviceAccountAdmin"
  member  = "serviceAccount:${google_service_account.github_tf_stg.email}"
}

resource "google_project_iam_member" "github_tf_stg_project_iam_admin" {
  project = var.project_id
  role    = "roles/resourcemanager.projectIamAdmin"
  member  = "serviceAccount:${google_service_account.github_tf_stg.email}"
}

resource "google_project_iam_member" "github_tf_stg_serviceusage_admin" {
  project = var.project_id
  role    = "roles/serviceusage.serviceUsageAdmin"
  member  = "serviceAccount:${google_service_account.github_tf_stg.email}"
}

resource "google_storage_bucket_iam_member" "github_tf_stg_tfstate_admin" {
  bucket = var.tfstate_bucket_name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.github_tf_stg.email}"
}
