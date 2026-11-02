# Terraform runner: only the roles its resources need, at the narrowest scope.
# roles/compute.securityAdmin exists only because the runner manages a
# firewall rule; roles/iam.serviceAccountUser is granted on the runtime
# service account itself, not on the project, so the runner can attach that
# identity and no other.

resource "google_project_iam_member" "runner_network_admin" {
  project = var.project_id
  role    = "roles/compute.networkAdmin"
  member  = "serviceAccount:${var.runner_service_account_email}"
}

resource "google_project_iam_member" "runner_security_admin" {
  project = var.project_id
  role    = "roles/compute.securityAdmin"
  member  = "serviceAccount:${var.runner_service_account_email}"
}

resource "google_project_iam_member" "runner_instance_admin" {
  project = var.project_id
  role    = "roles/compute.instanceAdmin.v1"
  member  = "serviceAccount:${var.runner_service_account_email}"
}

resource "google_service_account_iam_member" "runner_can_attach_app_identity" {
  service_account_id = "projects/${var.project_id}/serviceAccounts/${var.app_service_account_email}"
  role               = "roles/iam.serviceAccountUser"
  member             = "serviceAccount:${var.runner_service_account_email}"
}

# Backend access: object-level access on the state bucket only. The same
# runner identity performs this job, but the grant is scoped to the bucket,
# not the project.
resource "google_storage_bucket_iam_member" "runner_state_objects" {
  bucket = var.state_bucket
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${var.runner_service_account_email}"
}

# The runtime identity's only grant is in main.tf: secretAccessor on one
# secret. It holds no project-level role.
