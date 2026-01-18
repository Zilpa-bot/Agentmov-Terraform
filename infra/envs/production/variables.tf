variable "gateway_service_account_email" {
  type    = string
  default = "agentmov-gateway-runtime@agentmov-on-cloud-prod.iam.gserviceaccount.com"
}

variable "prod_lb_ip" {
  type        = string
  description = "Production LB IP address (A record for agentmov.com)"
  default     = ""
}

variable "github_owner" {
  type = string
}

variable "github_wif_pool_id" {
  type        = string
  description = "Workload Identity Pool ID for GitHub Actions"
}

variable "github_wif_provider_id" {
  type        = string
  description = "Workload Identity Pool Provider ID for GitHub Actions"
}

variable "github_wif_attribute_condition" {
  type        = string
  description = "CEL condition restricting GitHub OIDC tokens"
}

variable "tfstate_bucket_name" {
  type        = string
  description = "GCS bucket name for Terraform state"
}

variable "tf_github_wif_pool_id" {
  type        = string
  description = "Workload Identity Pool ID for Terraform GitHub Actions"
}

variable "tf_github_wif_provider_id" {
  type        = string
  description = "Workload Identity Pool Provider ID for Terraform GitHub Actions"
}

variable "tf_github_wif_attribute_condition" {
  type        = string
  description = "CEL condition restricting Terraform GitHub OIDC tokens"
}
