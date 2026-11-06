# Workspace sandbox for L05 Part B (M10).
#
# Disposable on purpose. It uses local state and the built-in terraform_data
# resource, so it touches nothing in Google Cloud and nothing in your GCS
# state bucket.

terraform {
  required_version = ">= 1.11"
}

locals {
  # terraform.workspace is the name of the selected CLI workspace.
  environment_name = "sandbox-${terraform.workspace}"
}

resource "terraform_data" "marker" {
  input = local.environment_name
}

output "selected_workspace" {
  description = "The CLI workspace this state belongs to."
  value       = terraform.workspace
}

output "environment_name" {
  description = "A name derived from the workspace: explicit naming makes the selected workspace visible."
  value       = terraform_data.marker.output
}
