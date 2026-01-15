variable "project_id" {
  type = string
}

variable "region" {
  type = string
}

variable "service_name" {
  type = string
}

variable "image" {
  type = string
}

variable "service_account_email" {
  type = string
}

variable "container_port" {
  type    = number
  default = 8080
}

variable "vpc_connector_id" {
  type        = string
  description = "projects/*/locations/*/connectors/* (optional)"
  default     = ""
}

variable "ingress" {
  type        = string
  description = "Cloud Run ingress setting"
  default     = "INGRESS_TRAFFIC_INTERNAL_ONLY"
}
