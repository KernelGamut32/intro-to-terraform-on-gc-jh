variable "project_id" {
  type    = string
  default = "jh-tf-lab-07"
}

variable "app_service_account_email" {
  type    = string
  default = "ledgerlite-app@jh-tf-lab-07.iam.gserviceaccount.com"
}

# FLAW: a plaintext secret with a default value lives in source control.
variable "billing_api_key" {
  type        = string
  description = "API key for the fictional billing gateway."
  default     = "blg_live_7Qk2mN9xT4wR8sV1pL6yH3cA0dF5gJ2e"
}

variable "db_password" {
  type    = string
  default = "Ledger#Autumn2026"
}
