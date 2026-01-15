variable "project_id" {
  type = string
}

variable "region" {
  type = string
}

variable "repository_id" {
  type = string
}

variable "description" {
  type    = string
  default = "Container images"
}

variable "format" {
  type    = string
  default = "DOCKER"
}

resource "google_artifact_registry_repository" "this" {
  project       = var.project_id
  location      = var.region
  repository_id = var.repository_id
  description   = var.description
  format        = var.format
}

output "repository_id" {
  value = google_artifact_registry_repository.this.repository_id
}

output "location" {
  value = google_artifact_registry_repository.this.location
}
