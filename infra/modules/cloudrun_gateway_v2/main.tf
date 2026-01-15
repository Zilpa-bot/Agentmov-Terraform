resource "google_cloud_run_v2_service" "this" {
  name     = var.service_name
  location = var.region
  project  = var.project_id

  ingress             = "INGRESS_TRAFFIC_INTERNAL_LOAD_BALANCER"
  deletion_protection = false

  template {
    service_account = var.service_account_email

    vpc_access {
      connector = var.vpc_connector_id
      egress    = "PRIVATE_RANGES_ONLY"
    }

    scaling {
      max_instance_count = 2
    }

    containers {
      name  = "gateway"
      image = var.image

      ports {
        container_port = var.container_port
      }

      env {
        name  = "DB_HOST"
        value = "127.0.0.1"
      }

      env {
        name  = "DB_PORT"
        value = tostring(var.db_port)
      }

      env {
        name = "DB_NAME"
        value_source {
          secret_key_ref {
            secret  = var.db_name_secret_id
            version = var.db_secret_version
          }
        }
      }

      env {
        name = "DB_USER"
        value_source {
          secret_key_ref {
            secret  = var.db_user_secret_id
            version = var.db_secret_version
          }
        }
      }

      env {
        name = "DB_PASSWORD"
        value_source {
          secret_key_ref {
            secret  = var.db_pass_secret_id
            version = var.db_secret_version
          }
        }
      }
    }

    containers {
      name  = "cloud-sql-proxy"
      image = "gcr.io/cloud-sql-connectors/cloud-sql-proxy:2.20.0"

      args = [
        "--address=0.0.0.0",
        "--port=5432",
        "--private-ip",
        var.instance_connection_name,
      ]
    }
  }

  traffic {
    type    = "TRAFFIC_TARGET_ALLOCATION_TYPE_LATEST"
    percent = 100
  }
}
