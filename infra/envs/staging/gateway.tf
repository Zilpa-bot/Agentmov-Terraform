module "gateway_stg" {
  source = "../../modules/cloudrun_gateway_v2"

  project_id = var.project_id
  region     = var.region

  service_name          = "agentmov-gateway"
  image                 = var.gateway_image
  service_account_email = var.gateway_service_account_email

  vpc_connector_id         = module.vpc_connector.id
  instance_connection_name = module.cloudsql_postgres.instance_connection_name

  db_name_secret_id = module.cloudsql_postgres.db_name_secret_id
  db_user_secret_id = module.cloudsql_postgres.db_user_secret_id
  db_pass_secret_id = module.cloudsql_postgres.db_password_secret_id

  db_secret_version = "latest"
}

module "agentmov_web_stg" {
  source = "../../modules/cloudrun_service_v2"

  project_id = var.project_id
  region     = var.region

  service_name          = "agentmov-web"
  image                 = var.agentmov_web_image
  service_account_email = var.gateway_service_account_email

  vpc_connector_id = module.vpc_connector.id
}

module "whatsapp_gateway_stg" {
  source = "../../modules/cloudrun_service_v2"

  project_id = var.project_id
  region     = var.region

  service_name          = "whatsapp-gateway"
  image                 = var.whatsapp_gateway_image
  service_account_email = var.gateway_service_account_email

  vpc_connector_id = module.vpc_connector.id
}
