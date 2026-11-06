terraform {
  # A reusable module declares the minimum versions it needs. It does not
  # configure a provider or a backend; the calling root module does that.
  required_version = ">= 1.11"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 8.0"
    }
  }
}
