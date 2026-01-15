variable "project_id" {
  description = "The GCP project ID for the environment."
  type        = string
}

variable "region" {
  description = "The GCP region where resources will be deployed."
  type        = string
  default     = "me-west1" # You can change this default if needed
}

variable "environment" {
  description = "Environment name (staging or prod)."
  type        = string
  default     = "staging"
  validation {
    condition     = contains(["staging", "prod"], var.environment)
    error_message = "environment must be one of: staging, prod."
  }
}

variable "allow_prod_apply" {
  description = "Safety switch to allow Terraform apply when environment=prod."
  type        = bool
  default     = false
}

variable "iap_oauth2_client_id" {
  description = "OAuth2 client ID for IAP (regional external LB)."
  type        = string
}

variable "iap_oauth2_client_secret" {
  description = "OAuth2 client secret for IAP (regional external LB)."
  type        = string
  sensitive   = true
}

variable "iap_members" {
  description = "IAM members allowed to access the LB via IAP (e.g., user:you@domain.com, group:team@domain.com)."
  type        = list(string)
}


