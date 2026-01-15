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

module "vpc_connector" {
  source     = "../../modules/vpc_connector"
  project_id = var.project_id
  region     = var.region

  name        = "agentmov-prod-vpc-conn"
  network     = module.network.vpc_self_link
  subnet_name = module.network.serverless_connector_subnet_name
}

module "artifact_registry" {
  source     = "../../modules/artifact_registry"
  project_id = var.project_id
  region     = var.region

  repository_id = "agentmov"
  description   = "Agentmov container images"
}

resource "google_artifact_registry_repository_iam_member" "gateway_runtime_reader" {
  project    = var.project_id
  location   = module.artifact_registry.location
  repository = module.artifact_registry.repository_id
  role       = "roles/artifactregistry.reader"
  member     = "serviceAccount:agentmov-gateway-runtime@${var.project_id}.iam.gserviceaccount.com"
}
