module "network" {
  source     = "../../modules/network"
  project_id = var.project_id
  region     = var.region
  name       = "agentmov-prod"

  app_subnet_cidr        = "10.20.0.0/24"
  proxy_only_subnet_cidr = "10.20.8.0/23"
  svpc_connector_cidr    = "10.20.4.0/28"

  psa_prefix_length = 16
}
