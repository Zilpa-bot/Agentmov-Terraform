terraform {
  required_version = ">= 1.6.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

provider "google" {
  project = var.project_id
}

resource "random_id" "suffix" {
  byte_length = 4
}

resource "google_storage_bucket" "tfstate" {
  name                        = "agentmov-tfstate-${var.env}-${random_id.suffix.hex}"
  location                    = var.location
  uniform_bucket_level_access = true

  versioning { enabled = true }

  public_access_prevention = "enforced"
}
