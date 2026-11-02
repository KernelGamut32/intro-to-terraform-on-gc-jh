# ledgerlite starter environment: VPC, subnet, narrowly scoped connectivity,
# and one Compute Engine instance with no external IP address.
# Checkpoint: end of M03. All TODO-M03 markers resolved.

# ---------------------------------------------------------------------------
# Network
# ---------------------------------------------------------------------------

resource "google_compute_network" "main" {
  name                    = "ledgerlite-vpc"
  auto_create_subnetworks = false
  description             = "ledgerlite lab network (Day 1 starter)"
}

resource "google_compute_subnetwork" "app" {
  name          = "ledgerlite-subnet-us-central1"
  ip_cidr_range = "10.10.0.0/24"
  region        = var.region

  # (1) The reference creates an implicit dependency: the subnet waits for
  # the network, and Terraform orders creation without depends_on.
  network = google_compute_network.main.id

  private_ip_google_access = true
}

# ---------------------------------------------------------------------------
# Connectivity: only Identity-Aware Proxy TCP forwarding may reach the app.
# ---------------------------------------------------------------------------

resource "google_compute_firewall" "allow_iap" {
  name      = "ledgerlite-allow-iap"
  network   = google_compute_network.main.id
  direction = "INGRESS"

  allow {
    protocol = "tcp"
    ports    = ["22", "8080"]
  }

  # (2) The published IAP TCP forwarding source range.
  source_ranges = ["35.235.240.0/20"]

  target_tags = ["ledgerlite-app"]
}

# ---------------------------------------------------------------------------
# Compute Engine instance
# ---------------------------------------------------------------------------

resource "google_compute_instance" "app" {
  name = "ledgerlite-app"
  zone = var.zone
  tags = ["ledgerlite-app"]

  # (3)
  machine_type = "e2-small"

  boot_disk {
    initialize_params {
      # (4) PROJECT/FAMILY resolves to the newest image in the family at
      # apply time. M04 replaces this with a data source lookup.
      image = "debian-cloud/debian-13"
      size  = 10
      type  = "pd-balanced"
    }
  }

  network_interface {
    # (5) Implicit dependency on the subnet. No access_config block, so no
    # external IP address is allocated.
    subnetwork = google_compute_subnetwork.app.id
  }

  service_account {
    email  = var.app_service_account_email
    scopes = ["cloud-platform"]
  }

  labels = {
    app        = "ledgerlite"
    managed_by = "terraform"
  }

  metadata_startup_script = templatefile("${path.module}/templates/startup.sh.tftpl", {
    app_name    = "ledgerlite"
    app_port    = 8080
    app_version = "0.9.0-starter"
    environment = "lab"
    team        = "platform-services"
  })
}
