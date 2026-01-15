variable "gateway_image" {
  type = string
}

variable "gateway_service_account_email" {
  type = string
}

variable "agentmov_web_image" {
  type = string
}

variable "whatsapp_gateway_image" {
  type = string
}

variable "stg_allow_cidrs" {
  type = list(string)
}

variable "stg_domain" {
  type = string
}
