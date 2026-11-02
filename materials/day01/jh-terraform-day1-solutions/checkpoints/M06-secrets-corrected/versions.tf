terraform {
  required_version = ">= 1.11"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 8.0"
    }
  }
}

# No credentials argument. Application Default Credentials on a workstation,
# Workload Identity Federation for automation. No key file exists to leak.
provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}
