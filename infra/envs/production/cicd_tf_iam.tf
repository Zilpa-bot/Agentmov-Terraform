resource "google_service_account" "github_tf_prod" {
  account_id   = "sa-github-tf-prod"
  display_name = "GitHub Actions Terraform (production)"
}

resource "google_project_iam_member" "github_tf_prod_run_admin" {
  project = var.project_id
  role    = "roles/run.admin"
  member  = "serviceAccount:${google_service_account.github_tf_prod.email}"
}

resource "google_project_iam_member" "github_tf_prod_compute_admin" {
  project = var.project_id
  role    = "roles/compute.admin"
  member  = "serviceAccount:${google_service_account.github_tf_prod.email}"
}

resource "google_project_iam_member" "github_tf_prod_cloudsql_admin" {
  project = var.project_id
  role    = "roles/cloudsql.admin"
  member  = "serviceAccount:${google_service_account.github_tf_prod.email}"
}

resource "google_project_iam_member" "github_tf_prod_secretmanager_admin" {
  project = var.project_id
  role    = "roles/secretmanager.admin"
  member  = "serviceAccount:${google_service_account.github_tf_prod.email}"
}

resource "google_project_iam_member" "github_tf_prod_servicenetworking_admin" {
  project = var.project_id
  role    = "roles/servicenetworking.networksAdmin"
  member  = "serviceAccount:${google_service_account.github_tf_prod.email}"
}

resource "google_project_iam_member" "github_tf_prod_vpcaccess_admin" {
  project = var.project_id
  role    = "roles/vpcaccess.admin"
  member  = "serviceAccount:${google_service_account.github_tf_prod.email}"
}

resource "google_project_iam_member" "github_tf_prod_artifactregistry_admin" {
  project = var.project_id
  role    = "roles/artifactregistry.admin"
  member  = "serviceAccount:${google_service_account.github_tf_prod.email}"
}

resource "google_project_iam_member" "github_tf_prod_certmanager_admin" {
  project = var.project_id
  role    = "roles/certificatemanager.editor"
  member  = "serviceAccount:${google_service_account.github_tf_prod.email}"
}

resource "google_project_iam_member" "github_tf_prod_dns_admin" {
  project = var.project_id
  role    = "roles/dns.admin"
  member  = "serviceAccount:${google_service_account.github_tf_prod.email}"
}

resource "google_project_iam_member" "github_tf_prod_iam_sa_admin" {
  project = var.project_id
  role    = "roles/iam.serviceAccountAdmin"
  member  = "serviceAccount:${google_service_account.github_tf_prod.email}"
}

resource "google_project_iam_member" "github_tf_prod_project_iam_admin" {
  project = var.project_id
  role    = "roles/resourcemanager.projectIamAdmin"
  member  = "serviceAccount:${google_service_account.github_tf_prod.email}"
}

resource "google_project_iam_member" "github_tf_prod_serviceusage_admin" {
  project = var.project_id
  role    = "roles/serviceusage.serviceUsageAdmin"
  member  = "serviceAccount:${google_service_account.github_tf_prod.email}"
}

resource "google_storage_bucket_iam_member" "github_tf_prod_tfstate_admin" {
  bucket = var.tfstate_bucket_name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.github_tf_prod.email}"
}
