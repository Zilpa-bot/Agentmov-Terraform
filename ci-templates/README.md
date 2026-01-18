Copy the workflows in this folder into the target repo under
`.github/workflows/`. Each service repo should contain two workflows:

1) `*-staging.yml` (runs on push to `main` and manual)
2) `*-production.yml` (runs on tag `v*` and manual)

Required GitHub Secrets per repo (use repo secrets or environment secrets):
- `GCP_WIF_PROVIDER_STG`
- `GCP_SA_EMAIL_STG`
- `GCP_PROJECT_ID_STG`
- `GCP_WIF_PROVIDER_PROD`
- `GCP_SA_EMAIL_PROD`
- `GCP_PROJECT_ID_PROD`

The workflows build and push a Docker image to Artifact Registry, deploy
by immutable image digest, and then update the Cloud Run service. They also
set `environment` to `staging` or `production` to enable required approvals.

Optional tests:
- If a repo has `ci/test.sh`, it will be executed before build/push.
