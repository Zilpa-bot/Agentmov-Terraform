data "google_project" "p" {
  project_id = var.project_id
}

resource "google_iam_workload_identity_pool" "pool" {
  project                   = var.project_id
  workload_identity_pool_id = var.pool_id
  display_name              = "GitHub Actions Pool"
}

resource "google_iam_workload_identity_pool_provider" "provider" {
  project                            = var.project_id
  workload_identity_pool_id          = google_iam_workload_identity_pool.pool.workload_identity_pool_id
  workload_identity_pool_provider_id = var.provider_id
  display_name                       = "GitHub OIDC Provider"

  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }

  attribute_mapping = {
    "google.subject"         = "assertion.sub"
    "attribute.repository"   = "assertion.repository"
    "attribute.owner"        = "assertion.repository_owner"
    "attribute.ref"          = "assertion.ref"
    "attribute.actor"        = "assertion.actor"
    "attribute.workflow_ref" = "assertion.workflow_ref"
  }

  attribute_condition = var.attribute_condition
}

locals {
  wif_member = "principalSet://iam.googleapis.com/projects/${data.google_project.p.number}/locations/global/workloadIdentityPools/${google_iam_workload_identity_pool.pool.workload_identity_pool_id}/attribute.owner/${var.github_owner}"
}

resource "null_resource" "wif_user_binding" {
  triggers = {
    service_account = var.deployer_sa_email
    member          = local.wif_member
  }

  provisioner "local-exec" {
    command = "gcloud iam service-accounts add-iam-policy-binding ${var.deployer_sa_email} --project ${var.project_id} --member \"${local.wif_member}\" --role roles/iam.workloadIdentityUser --quiet"
    interpreter = ["powershell", "-Command"]
  }
}
