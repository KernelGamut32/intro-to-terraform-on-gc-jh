# Authentication comes from Application Default Credentials on the
# workstation. No credentials appear in this file. Project, region, and zone
# are set explicitly rather than inherited from gcloud defaults.
provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone

  # Uncomment only if the instructor has prepared impersonation for your lab.
  # The caller needs roles/iam.serviceAccountTokenCreator on that account.
  # impersonate_service_account = "tf-runner@PROJECT_ID.iam.gserviceaccount.com"
}
