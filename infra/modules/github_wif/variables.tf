variable "project_id" {
  type = string
}

variable "pool_id" {
  type        = string
  description = "Workload Identity Pool ID"
}

variable "provider_id" {
  type        = string
  description = "Workload Identity Pool Provider ID"
}

variable "github_owner" {
  type        = string
  description = "GitHub organization or user"
}

variable "attribute_condition" {
  type        = string
  description = "CEL condition restricting GitHub tokens"
}

variable "deployer_sa_email" {
  type        = string
  description = "Service account email to impersonate via WIF"
}
