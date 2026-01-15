resource "null_resource" "disable_gateway_default_url" {
  triggers = {
    project = var.project_id
    region  = var.region
    service = module.gateway_stg.service_name
  }

  depends_on = [module.gateway_stg]

  provisioner "local-exec" {
    interpreter = ["powershell", "-Command"]
    command     = "gcloud run services update ${module.gateway_stg.service_name} --project ${var.project_id} --region ${var.region} --no-default-url"
  }
}
