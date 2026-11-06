# Second placement of ledgerlite. Same project, different region. This root
# has its own state location; it never writes to the primary root's state.
provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}
