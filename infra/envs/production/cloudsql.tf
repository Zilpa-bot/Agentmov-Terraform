module "cloudsql_postgres" {
  source = "../../modules/cloudsql_postgres"

  project_id = var.project_id
  region     = var.region

  instance_name     = "agentmov-prod-pg"
  database_version  = "POSTGRES_16"
  tier              = "db-custom-2-8192"
  edition           = "ENTERPRISE"
  availability_type = "REGIONAL"

  network_self_link       = module.network.vpc_id
  allocated_ip_range_name = module.network.psa_range_name

  db_name     = "agentmov"
  app_db_user = "agentmov_app"

  enable_pitr         = true
  retained_log_days   = 7
  deletion_protection = true
}
