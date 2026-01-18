# Agentmov Terraformmmm

## Terraform CI/CD checklist

- GCS backend enabled in each env (`infra/envs/staging`, `infra/envs/production`).
- Terraform state bucket permissions are granted to the Terraform GitHub SAs.
- Workflows never use `-lock=false` (state locking stays enabled).
- WIF conditions restrict repos/refs to approved patterns.
- `stg.agentmov.com` delegation is active; do not delete the staging zone while
  NS delegation exists.
