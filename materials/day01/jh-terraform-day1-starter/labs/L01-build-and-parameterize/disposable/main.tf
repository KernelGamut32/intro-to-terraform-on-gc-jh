terraform {
  required_version = ">= 1.11"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 8.0"
    }
  }
}

variable "project_id" {
  type        = string
  description = "Your lab project ID."
}

variable "zone" {
  type    = string
  default = "us-central1-a"
}

provider "google" {
  project = var.project_id
  zone    = var.zone
}

# A small standard persistent disk: cheap, quick to create, quick to destroy.
resource "google_compute_disk" "scratch" {
  name = "ledgerlite-scratch-disk"
  type = "pd-standard"
  zone = var.zone
  size = 10

  labels = {
    purpose    = "disposable"
    managed_by = "terraform"
  }
}

output "disk_self_link" {
  value = google_compute_disk.scratch.self_link
}
