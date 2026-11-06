# Minimal usage example for the app_instance module.
#
# An example is a root module. It configures the provider and supplies real
# inputs; the module itself never configures a provider. Run it in a
# disposable project:
#
#   terraform init
#   terraform plan -var project_id=PROJECT -var subnetwork=SUBNET_ID \
#     -var service_account_email=SA_EMAIL

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
}

variable "project_id" {
  type        = string
  description = "Project that receives the example instance."
}

variable "subnetwork" {
  type        = string
  description = "ID of an existing subnetwork in us-central1."
}

variable "service_account_email" {
  type        = string
  description = "Runtime service account for the example instance."
}

data "google_compute_image" "debian" {
  family  = "debian-13"
  project = "debian-cloud"
}

module "app" {
  source = "../.."

  name                  = "example-app"
  zone                  = "us-central1-a"
  subnetwork            = var.subnetwork
  boot_image            = data.google_compute_image.debian.self_link
  service_account_email = var.service_account_email
  network_tags          = ["example-app"]
  labels                = { purpose = "module-example" }

  app = {
    name        = "example"
    port        = 8080
    version     = "1.0.0"
    environment = "dev"
    team        = "platform-services"
  }
}

output "instance_name" {
  description = "Name of the example instance."
  value       = module.app.instance_name
}
