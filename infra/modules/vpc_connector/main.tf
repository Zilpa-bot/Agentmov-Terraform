variable "project_id" {
  type = string
}

variable "region" {
  type = string
}

variable "name" {
  type = string
}

variable "network" {
  description = "VPC network self_link or name"
  type        = string
}

variable "subnet_name" {
  description = "Dedicated /28 subnet name for this connector (no other resources)"
  type        = string
}

variable "min_instances" {
  type    = number
  default = 2
}

variable "max_instances" {
  type    = number
  default = 3
}

variable "machine_type" {
  type    = string
  default = "e2-micro"
}

resource "google_project_service" "vpcaccess" {
  project            = var.project_id
  service            = "vpcaccess.googleapis.com"
  disable_on_destroy = false
}

resource "google_vpc_access_connector" "this" {
  project       = var.project_id
  name          = var.name
  region        = var.region
  machine_type  = var.machine_type
  min_instances = var.min_instances
  max_instances = var.max_instances

  subnet {
    name = var.subnet_name
  }

  depends_on = [google_project_service.vpcaccess]
}

output "id" {
  value = google_vpc_access_connector.this.id
}

output "name" {
  value = google_vpc_access_connector.this.name
}

output "region" {
  value = google_vpc_access_connector.this.region
}
