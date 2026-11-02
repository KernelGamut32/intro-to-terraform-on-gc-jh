# The secret container is managed here. Its VALUE is not: it is added by an
# authorized operator or a rotation job, or seeded with a write-only argument
# from an ephemeral variable as shown in D06. Either way the value never
# appears in this state file.
resource "google_secret_manager_secret" "billing_api_key" {
  secret_id = var.billing_api_key_secret_id

  replication {
    auto {}
  }

  labels = {
    app        = "ledgerlite"
    managed_by = "terraform"
  }
}

# Runtime identity: read access to this one secret, nothing else.
resource "google_secret_manager_secret_iam_member" "app_reads_billing_key" {
  secret_id = google_secret_manager_secret.billing_api_key.id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${var.app_service_account_email}"
}

resource "google_compute_instance" "app" {
  name         = "ledgerlite-app"
  machine_type = "e2-small"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-13"
    }
  }

  network_interface {
    subnetwork = "ledgerlite-subnet-us-central1"
    # No access_config: no external IP. Operators connect through IAP.
  }

  service_account {
    email  = var.app_service_account_email
    scopes = ["cloud-platform"]
  }

  # Only the secret's NAME travels through metadata. The workload exchanges
  # its attached identity for the value at startup.
  metadata = {
    billing-api-key-secret = google_secret_manager_secret.billing_api_key.secret_id
  }

  metadata_startup_script = <<-EOT
    #!/bin/bash
    set -euo pipefail
    SECRET_ID=$(curl -sf -H "Metadata-Flavor: Google" \
      http://metadata.google.internal/computeMetadata/v1/instance/attributes/billing-api-key-secret)
    # The attached service account authorizes this call. The value stays in
    # memory on the instance and is written to a root-only file.
    mkdir -p /etc/ledgerlite
    install -m 600 /dev/null /etc/ledgerlite/billing.key
    gcloud secrets versions access latest --secret="$SECRET_ID" > /etc/ledgerlite/billing.key
  EOT
}

# Outputs name the secret; they never carry its value.
output "billing_api_key_secret_name" {
  value = google_secret_manager_secret.billing_api_key.name
}
