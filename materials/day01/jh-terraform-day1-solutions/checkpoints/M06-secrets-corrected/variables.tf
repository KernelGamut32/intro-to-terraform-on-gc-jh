variable "project_id" {
  type        = string
  description = "Lab project ID."
}

variable "region" {
  type    = string
  default = "us-central1"
}

variable "zone" {
  type    = string
  default = "us-central1-a"
}

variable "app_service_account_email" {
  type        = string
  description = "Runtime identity attached to the instance."
}

variable "runner_service_account_email" {
  type        = string
  description = "Identity that runs terraform plan and apply in automation."
}

variable "state_bucket" {
  type        = string
  description = "Name of the GCS bucket holding Terraform state."
}

# The configuration references the secret by NAME. No secret value is ever
# an input to this configuration.
variable "billing_api_key_secret_id" {
  type        = string
  description = "Secret Manager secret ID (not the value) that the application reads at startup."
  default     = "ledgerlite-billing-api-key"
}
