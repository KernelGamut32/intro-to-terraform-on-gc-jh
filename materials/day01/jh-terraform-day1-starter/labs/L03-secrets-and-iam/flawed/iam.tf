# FLAW: the Terraform runner is granted Owner on the whole project.
resource "google_project_iam_member" "runner_owner" {
  project = var.project_id
  role    = "roles/owner"
  member  = "serviceAccount:tf-runner@jh-tf-lab-07.iam.gserviceaccount.com"
}

# FLAW: the application identity is granted Editor on the whole project.
resource "google_project_iam_member" "app_editor" {
  project = var.project_id
  role    = "roles/editor"
  member  = "serviceAccount:${var.app_service_account_email}"
}

# FLAW: the state bucket user is granted Storage Admin on every bucket in the
# project instead of object access on the state bucket only.
resource "google_project_iam_member" "backend_storage_admin" {
  project = var.project_id
  role    = "roles/storage.admin"
  member  = "group:platform-services-all@jhlabs.example"
}
