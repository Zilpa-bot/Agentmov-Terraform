module "cloudsql_postgres" {
  source = "../../modules/cloudsql_postgres"

  project_id = var.project_id
  region     = var.region

  instance_name     = "agentmov-stg-pg"
  database_version  = "POSTGRES_16"
  tier              = "db-custom-1-3840"
  edition           = "ENTERPRISE"
  availability_type = "ZONAL"

  network_self_link       = module.network.vpc_id
  allocated_ip_range_name = module.network.psa_range_name

  db_name     = "agentmov"
  app_db_user = "agentmov_app"

  enable_pitr         = false
  deletion_protection = false
}
