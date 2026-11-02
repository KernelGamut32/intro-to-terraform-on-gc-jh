# ---------------------------------------------------------------------------
# Location and identity
# ---------------------------------------------------------------------------

variable "project_id" {
  type        = string
  description = "Google Cloud project ID assigned to you for the lab."
}

variable "region" {
  type        = string
  description = "Region for regional resources such as the subnet."
  default     = "us-central1"

  validation {
    condition     = contains(["us-central1", "us-east1"], var.region)
    error_message = "Region must be one of the approved lab regions: us-central1 or us-east1."
  }
}

variable "zone" {
  type        = string
  description = "Zone for the Compute Engine instance. Must be inside var.region."
  default     = "us-central1-a"

  validation {
    # Cross-variable references in validation are supported from Terraform 1.9.
    condition     = startswith(var.zone, "${var.region}-")
    error_message = "Zone must belong to the selected region, for example us-central1-a for us-central1."
  }
}

variable "app_service_account_email" {
  type        = string
  description = "Email of the runtime service account attached to the instance (pre-created by the instructor)."

  validation {
    condition     = endswith(var.app_service_account_email, ".iam.gserviceaccount.com")
    error_message = "Provide a service account email ending in .iam.gserviceaccount.com."
  }
}

# ---------------------------------------------------------------------------
# Naming and network
# ---------------------------------------------------------------------------

variable "name_prefix" {
  type        = string
  description = "Prefix applied to every resource name."
  default     = "ledgerlite"

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{2,19}$", var.name_prefix))
    error_message = "name_prefix must be 3 to 20 characters: lowercase letters, digits, and hyphens, starting with a letter."
  }
}

variable "subnet_cidr" {
  type        = string
  description = "CIDR range for the application subnet."
  default     = "10.10.0.0/24"

  validation {
    condition     = can(cidrhost(var.subnet_cidr, 0))
    error_message = "subnet_cidr must be a valid IPv4 CIDR block, for example 10.10.0.0/24."
  }
}

variable "iap_source_ranges" {
  type        = list(string)
  description = "Source ranges allowed to reach the instance. Defaults to the IAP TCP forwarding range."
  default     = ["35.235.240.0/20"]
}

# ---------------------------------------------------------------------------
# Instance
# ---------------------------------------------------------------------------

variable "machine_type" {
  type        = string
  description = "Compute Engine machine type for the application instance."
  default     = "e2-small"

  validation {
    condition     = contains(["e2-micro", "e2-small", "e2-medium"], var.machine_type)
    error_message = "machine_type must be one of e2-micro, e2-small, or e2-medium for this lab."
  }
}

variable "image_family" {
  type        = string
  description = "Public image family to look up."
  default     = "debian-13"
}

variable "image_project" {
  type        = string
  description = "Project that publishes the image family."
  default     = "debian-cloud"
}

variable "app_port" {
  type        = number
  description = "TCP port the application listens on."
  default     = 8080

  validation {
    condition     = var.app_port >= 1024 && var.app_port <= 65535
    error_message = "app_port must be an unprivileged port between 1024 and 65535."
  }
}

# ---------------------------------------------------------------------------
# CR-2041 additions
# ---------------------------------------------------------------------------

variable "environment" {
  type        = string
  description = "Deployment environment. Day 1 supports dev and test only."
  default     = "dev"

  validation {
    condition     = contains(["dev", "test"], var.environment)
    error_message = "environment must be dev or test."
  }
}

variable "app_version" {
  type        = string
  description = "Semantic version of the application rendered into the startup page."
  default     = "1.0.0"

  validation {
    condition     = can(regex("^[0-9]+\\.[0-9]+\\.[0-9]+$", var.app_version))
    error_message = "app_version must be a semantic version such as 1.2.0."
  }
}

variable "team" {
  type        = string
  description = "Owning team, rendered into labels and the startup page."
  default     = "platform-services"
}

variable "labels" {
  type        = map(string)
  description = "Additional labels merged onto the instance."
  default = {
    cost_center = "cc-4410"
  }
}
