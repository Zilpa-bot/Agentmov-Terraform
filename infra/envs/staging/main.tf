module "network" {
  source     = "../../modules/network"
  project_id = var.project_id
  region     = var.region
  name       = "agentmov-stg"

  app_subnet_cidr        = "10.10.0.0/24"
  proxy_only_subnet_cidr = "10.10.8.0/23"
  svpc_connector_cidr    = "10.10.4.0/28"

  psa_prefix_length = 16
}

module "vpc_connector" {
  source     = "../../modules/vpc_connector"
  project_id = var.project_id
  region     = var.region

  name        = "agentmov-stg-vpc-conn"
  network     = module.network.vpc_self_link
  subnet_name = module.network.serverless_connector_subnet_name
}
