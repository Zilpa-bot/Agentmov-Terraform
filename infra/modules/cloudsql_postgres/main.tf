terraform {
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

resource "random_password" "app_user_password" {
  length  = 32
  special = true
}

resource "google_secret_manager_secret" "app_user_password" {
  project   = var.project_id
  secret_id = "${var.instance_name}-app-user-password"

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "app_user_password" {
  secret      = google_secret_manager_secret.app_user_password.id
  secret_data = random_password.app_user_password.result
}

resource "google_sql_database_instance" "pg" {
  project          = var.project_id
  name             = var.instance_name
  region           = var.region
  database_version = var.database_version

  settings {
    tier              = var.tier
    availability_type = var.availability_type
    edition           = var.edition

    disk_type       = "PD_SSD"
    disk_autoresize = true

    ip_configuration {
      ipv4_enabled       = false
      private_network    = var.network_self_link
      allocated_ip_range = var.allocated_ip_range_name
      ssl_mode           = var.ssl_mode
    }

    backup_configuration {
      enabled                        = true
      start_time                     = var.backup_start_time_utc
      point_in_time_recovery_enabled = var.enable_pitr
      transaction_log_retention_days = var.enable_pitr ? var.retained_log_days : null
    }

    maintenance_window {
      day          = 7
      hour         = 3
      update_track = "stable"
    }
  }

  deletion_protection = var.deletion_protection
}

resource "google_sql_database" "appdb" {
  project  = var.project_id
  instance = google_sql_database_instance.pg.name
  name     = var.db_name
}

resource "google_sql_user" "app" {
  project  = var.project_id
  instance = google_sql_database_instance.pg.name
  name     = var.app_db_user
  password = random_password.app_user_password.result
}
