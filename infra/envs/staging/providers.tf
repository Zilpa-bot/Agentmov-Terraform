variable "project_id" { type = string }
variable "region" { type = string }

provider "google" {
  project                     = var.project_id
  region                      = var.region
  impersonate_service_account = "tf-deployer@agentmov-on-cloud-staging.iam.gserviceaccount.com"
}
