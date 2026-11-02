resource "google_secret_manager_secret" "billing_api_key" {
  secret_id = "ledgerlite-billing-api-key"
  replication {
    auto {}
  }
}

# FLAW: secret_data is a regular argument. Its value persists in state and in
# every saved plan, even though it came from a variable.
resource "google_secret_manager_secret_version" "billing_api_key" {
  secret      = google_secret_manager_secret.billing_api_key.id
  secret_data = var.billing_api_key
}

resource "google_compute_instance" "app" {
  name         = "ledgerlite-app"
  machine_type = "e2-small"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-13"
    }
  }

  network_interface {
    subnetwork = "ledgerlite-subnet-us-central1"
    access_config {} # FLAW: an external IP the application does not need.
  }

  service_account {
    email  = var.app_service_account_email
    scopes = ["cloud-platform"]
  }

  # FLAW: the secret is pushed into instance metadata, readable by anyone
  # who can describe the instance.
  metadata = {
    billing-api-key = var.billing_api_key
    db-password     = var.db_password
  }
}

# FLAW: outputs that reveal the secret. sensitive = true only redacts display.
output "billing_api_key" {
  value     = var.billing_api_key
  sensitive = true
}

output "db_password" {
  value = var.db_password
}
