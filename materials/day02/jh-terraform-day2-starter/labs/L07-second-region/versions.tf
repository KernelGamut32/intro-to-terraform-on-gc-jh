terraform {
  # 1.11 or later provides ephemeral values (1.10) and write-only arguments
  # (1.11), both used in M06. The tested line is recorded in VERSIONS.md.
  required_version = ">= 1.11"

  required_providers {
    google = {
      source = "hashicorp/google"
      # Track the current 8.x line; block an unreviewed jump to 9.0.
      version = "~> 8.0"
    }
  }
}
