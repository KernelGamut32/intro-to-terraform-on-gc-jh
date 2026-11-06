# Inputs for the app_instance module.
#
# Every input needs a type and a description. Add validation where a bad
# value would otherwise fail late, at apply time, with a provider error.

# ---------------------------------------------------------------------------
# Required inputs: the caller must decide these.
# ---------------------------------------------------------------------------

# TODO-M09 (1): declare `name`.
#   type         string
#   description  say that it must be unique within the project and zone
#   validation   condition:  can(regex("^[a-z]([-a-z0-9]{0,61}[a-z0-9])?$", var.name))
#                write an error_message you would want to read at 2 a.m.

variable "zone" {
  type        = string
  description = "Zone for the instance, for example us-central1-a. Must be in the same region as the subnetwork."

  validation {
    condition     = can(regex("^[a-z]+-[a-z]+[0-9]+-[a-z]$", var.zone))
    error_message = "zone must look like us-central1-a."
  }
}

# TODO-M09 (2): declare `subnetwork`.
#   type         string
#   description  the ID or self link of the subnetwork to attach to

variable "boot_image" {
  type        = string
  description = "Self link of the boot image. The caller chooses the image, usually with a google_compute_image data source."
}

variable "service_account_email" {
  type        = string
  description = "Email of the runtime service account attached to the instance."

  validation {
    condition     = endswith(var.service_account_email, ".iam.gserviceaccount.com")
    error_message = "Provide a service account email ending in .iam.gserviceaccount.com."
  }
}

# TODO-M09 (3): declare `app`, a single object that carries the application
# settings rendered into the startup page. main.tf reads these attributes:
#   var.app.name         string
#   var.app.port         number
#   var.app.version      string
#   var.app.environment  string
#   var.app.team         string
# Add a validation that keeps port between 1024 and 65535.

# ---------------------------------------------------------------------------
# Optional inputs: sensible defaults, override when needed.
# ---------------------------------------------------------------------------

variable "machine_type" {
  type        = string
  description = "Compute Engine machine type."
  default     = "e2-small"

  validation {
    condition     = contains(["e2-micro", "e2-small", "e2-medium"], var.machine_type)
    error_message = "machine_type must be one of e2-micro, e2-small, or e2-medium."
  }
}

variable "network_tags" {
  type        = list(string)
  description = "Network tags applied to the instance. Firewall rules select instances by these tags."
  default     = []
}

# TODO-M09 (4): declare `labels`.
#   type         a map of strings
#   description  labels applied to the instance
#   default      an empty map, so callers can leave it out
