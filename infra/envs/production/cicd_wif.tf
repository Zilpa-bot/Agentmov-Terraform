module "github_wif" {
  source = "../../modules/github_wif"

  project_id = var.project_id

  pool_id     = var.github_wif_pool_id
  provider_id = var.github_wif_provider_id

  github_owner        = var.github_owner
  attribute_condition = var.github_wif_attribute_condition
  deployer_sa_email   = google_service_account.github_deploy_prod.email
}

module "github_wif_tf" {
  source = "../../modules/github_wif"

  project_id = var.project_id

  pool_id     = var.tf_github_wif_pool_id
  provider_id = var.tf_github_wif_provider_id

  github_owner        = var.github_owner
  attribute_condition = var.tf_github_wif_attribute_condition
  deployer_sa_email   = google_service_account.github_tf_prod.email
}
