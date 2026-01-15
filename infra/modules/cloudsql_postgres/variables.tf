variable "project_id" {
  type = string
}

variable "region" {
  type = string
}

variable "instance_name" {
  type = string
}

variable "database_version" {
  type    = string
  default = "POSTGRES_16"
}

variable "tier" {
  type = string
}

variable "edition" {
  type    = string
  default = "ENTERPRISE"
}

variable "availability_type" {
  type = string
}

variable "network_self_link" {
  type = string
}

variable "allocated_ip_range_name" {
  type = string
}

variable "db_name" {
  type = string
}

variable "app_db_user" {
  type = string
}

variable "backup_start_time_utc" {
  type    = string
  default = "02:00"
}

variable "enable_pitr" {
  type    = bool
  default = false
}

variable "retained_log_days" {
  type    = number
  default = 7
}

variable "ssl_mode" {
  type    = string
  default = "ENCRYPTED_ONLY"
}

variable "deletion_protection" {
  type    = bool
  default = false
}

