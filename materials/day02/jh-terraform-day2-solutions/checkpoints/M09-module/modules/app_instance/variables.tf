# ---------------------------------------------------------------------------
# Required inputs: the caller must decide these.
# ---------------------------------------------------------------------------

variable "name" {
  type        = string
  description = "Instance name. Must be unique within the project and zone."

  validation {
    condition     = can(regex("^[a-z]([-a-z0-9]{0,61}[a-z0-9])?$", var.name))
    error_message = "name must be 1 to 63 characters: lowercase letters, digits, and hyphens, starting with a letter and not ending with a hyphen."
  }
}

variable "zone" {
  type        = string
  description = "Zone for the instance, for example us-central1-a. Must be in the same region as the subnetwork."

  validation {
    condition     = can(regex("^[a-z]+-[a-z]+[0-9]+-[a-z]$", var.zone))
    error_message = "zone must look like us-central1-a."
  }
}

variable "subnetwork" {
  type        = string
  description = "ID or self link of the subnetwork to attach the instance to."
}

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

variable "app" {
  type = object({
    name        = string
    port        = number
    version     = string
    environment = string
    team        = string
  })
  description = "Application settings rendered into the startup page."

  validation {
    condition     = var.app.port >= 1024 && var.app.port <= 65535
    error_message = "app.port must be an unprivileged port between 1024 and 65535."
  }
}

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

variable "labels" {
  type        = map(string)
  description = "Labels applied to the instance."
  default     = {}
}
