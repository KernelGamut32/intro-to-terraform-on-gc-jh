# Part A and Part B use only these four inputs. Part C adds more.

variable "project_id" {
  type        = string
  description = "Google Cloud project ID assigned to you for the lab."
}

variable "region" {
  type        = string
  description = "Region for regional resources such as the subnet."
  default     = "us-central1"
}

variable "zone" {
  type        = string
  description = "Zone for the Compute Engine instance. Must be inside var.region."
  default     = "us-central1-a"
}

variable "app_service_account_email" {
  type        = string
  description = "Email of the runtime service account attached to the instance (pre-created by the instructor)."
}
