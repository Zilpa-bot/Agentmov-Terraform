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

variable "vpc_connector_id" {
  type        = string
  description = "projects/*/locations/*/connectors/*"
}

variable "instance_connection_name" {
  type        = string
  description = "PROJECT:REGION:INSTANCE (Cloud SQL connection name)"
}

variable "container_port" {
  type    = number
  default = 8080
}

variable "db_port" {
  type    = number
  default = 5432
}

variable "db_name_secret_id" {
  type = string
}

variable "db_user_secret_id" {
  type = string
}

variable "db_pass_secret_id" {
  type = string
}

variable "db_secret_version" {
  type    = string
  default = "latest"
}
