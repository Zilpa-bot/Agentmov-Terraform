variable "project_id" {
  type = string
}

variable "region" {
  type = string
}

variable "name" {
  type = string
}

variable "cloud_run_service_name" {
  type = string
}

variable "allow_cidrs" {
  type        = list(string)
  description = "List of CIDR ranges that may access staging via the LB"
}

variable "enable_armor" {
  type    = bool
  default = true
}

variable "enable_https" {
  type    = bool
  default = true
}

variable "domain" {
  type        = string
  description = "Domain name for HTTPS certificate and redirects"
  default     = ""
}

