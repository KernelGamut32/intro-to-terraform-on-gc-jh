terraform {
  required_version = ">= 1.11"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 8.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = "us-central1"
  zone    = "us-central1-a"

  # FLAW: a service account key file checked into the repository.
  credentials = file("${path.module}/tf-runner-key.json")
}
