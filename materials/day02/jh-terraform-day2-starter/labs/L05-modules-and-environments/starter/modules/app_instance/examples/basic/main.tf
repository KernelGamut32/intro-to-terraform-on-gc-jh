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
  # Two levels up from examples/basic is the module itself.
  source = "../.."

  # TODO-M09 (9): complete the call. Pass every required input of the
  # module. Use the example's variables and data source where they fit and
  # literal example values for the rest.
  name = "example-app"
  zone = "us-central1-a"
}

output "instance_name" {
  description = "Name of the example instance."
  value       = module.app.instance_name
}
