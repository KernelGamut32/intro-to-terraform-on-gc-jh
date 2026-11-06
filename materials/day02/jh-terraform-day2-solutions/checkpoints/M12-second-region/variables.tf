# ---------------------------------------------------------------------------
# Location and identity
# ---------------------------------------------------------------------------

variable "project_id" {
  type        = string
  description = "Google Cloud project ID assigned to you for the lab."
}

variable "region" {
  type        = string
  description = "Region for the second placement."
  default     = "us-east1"

  validation {
    condition     = contains(["us-central1", "us-east1"], var.region)
    error_message = "Region must be one of the approved lab regions: us-central1 or us-east1."
  }
}

variable "zone" {
  type        = string
  description = "Zone for the instance. Must be inside var.region."
  default     = "us-east1-b"

  validation {
    condition     = startswith(var.zone, "${var.region}-")
    error_message = "Zone must belong to the selected region, for example us-east1-b for us-east1."
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
# Shared foundation: where the primary root publishes its outputs
# ---------------------------------------------------------------------------

variable "state_bucket" {
  type        = string
  description = "State bucket that holds the primary root's state."
}

variable "primary_state_prefix" {
  type        = string
  description = "Backend prefix of the primary root, for example labs/lab-07."
}

# ---------------------------------------------------------------------------
# Naming and network
# ---------------------------------------------------------------------------

variable "name_prefix" {
  type        = string
  description = "Prefix applied to every resource name. Use the same prefix as the primary root."
  default     = "ledgerlite"

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{2,19}$", var.name_prefix))
    error_message = "name_prefix must be 3 to 20 characters: lowercase letters, digits, and hyphens, starting with a letter."
  }
}

variable "subnet_cidr" {
  type        = string
  description = "CIDR range for the second-region subnet. Must not overlap the primary subnet."
  default     = "10.20.0.0/24"

  validation {
    condition     = can(cidrhost(var.subnet_cidr, 0))
    error_message = "subnet_cidr must be a valid IPv4 CIDR block, for example 10.20.0.0/24."
  }
}

# ---------------------------------------------------------------------------
# Instance and application
# ---------------------------------------------------------------------------

variable "machine_type" {
  type        = string
  description = "Compute Engine machine type for the application instance."
  default     = "e2-small"
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
}

variable "app_version" {
  type        = string
  description = "Semantic version of the application rendered into the startup page."
  default     = "1.0.0"
}

variable "environment" {
  type        = string
  description = "Deployment environment."
  default     = "dev"

  validation {
    condition     = contains(["dev", "test"], var.environment)
    error_message = "environment must be dev or test."
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
  default     = {}
}
