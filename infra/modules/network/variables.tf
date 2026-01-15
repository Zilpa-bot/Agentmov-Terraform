variable "project_id" {
  type = string
}

variable "region" {
  type = string
}

variable "name" {
  type = string
}

variable "app_subnet_cidr" {
  type = string
}

variable "proxy_only_subnet_cidr" {
  type = string
}

variable "svpc_connector_cidr" {
  type = string
}

variable "psa_prefix_length" {
  type    = number
  default = 16
}
