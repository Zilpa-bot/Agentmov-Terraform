data "terraform_remote_state" "stg" {
  backend = "gcs"
  config = {
    bucket = "agentmov-tfstate-stg-de1c2daa"
    prefix = "agentmov/staging"
  }
}

resource "google_dns_record_set" "delegate_stg" {
  managed_zone = google_dns_managed_zone.agentmov_com.name
  name         = "stg.agentmov.com."
  type         = "NS"
  ttl          = 300
  rrdatas      = data.terraform_remote_state.stg.outputs.stg_name_servers
}
