resource "google_cloud_run_v2_service" "this" {
  name     = var.service_name
  location = var.region
  project  = var.project_id

  ingress             = var.ingress
  deletion_protection = false

  template {
    service_account = var.service_account_email

    dynamic "vpc_access" {
      for_each = var.vpc_connector_id == "" ? [] : [var.vpc_connector_id]
      content {
        connector = vpc_access.value
        egress    = "PRIVATE_RANGES_ONLY"
      }
    }

    containers {
      name  = var.service_name
      image = var.image

      ports {
        container_port = var.container_port
      }
    }
  }

  traffic {
    type    = "TRAFFIC_TARGET_ALLOCATION_TYPE_LATEST"
    percent = 100
  }
}
