# ledgerlite environment, parameterized (checkpoint: CR-2041 complete).

locals {
  # merge() lets the caller add labels without losing the required ones.
  common_labels = merge(var.labels, {
    app         = var.name_prefix
    environment = var.environment
    team        = var.team
    managed_by  = "terraform"
  })
}

# ---------------------------------------------------------------------------
# Data source: read the newest image in the approved family. A data source
# reads an existing object; it does not manage it.
# ---------------------------------------------------------------------------

data "google_compute_image" "app" {
  family  = var.image_family
  project = var.image_project
}

# ---------------------------------------------------------------------------
# Network
# ---------------------------------------------------------------------------

resource "google_compute_network" "main" {
  name                    = "${var.name_prefix}-vpc"
  auto_create_subnetworks = false
  description             = "${var.name_prefix} lab network"
}

resource "google_compute_subnetwork" "app" {
  name                     = "${var.name_prefix}-subnet-${var.region}"
  ip_cidr_range            = var.subnet_cidr
  region                   = var.region
  network                  = google_compute_network.main.id
  private_ip_google_access = true
}

resource "google_compute_firewall" "allow_iap" {
  name      = "${var.name_prefix}-allow-iap"
  network   = google_compute_network.main.id
  direction = "INGRESS"

  allow {
    protocol = "tcp"
    ports    = ["22", tostring(var.app_port)]
  }

  source_ranges = var.iap_source_ranges
  target_tags   = ["${var.name_prefix}-app"]
}

# ---------------------------------------------------------------------------
# Compute Engine instance
# ---------------------------------------------------------------------------

resource "google_compute_instance" "app" {
  name         = "${var.name_prefix}-app"
  machine_type = var.machine_type
  zone         = var.zone
  tags         = ["${var.name_prefix}-app"]
  labels       = local.common_labels

  boot_disk {
    initialize_params {
      image = data.google_compute_image.app.self_link
      size  = 10
      type  = "pd-balanced"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.app.id
  }

  service_account {
    email  = var.app_service_account_email
    scopes = ["cloud-platform"]
  }

  metadata_startup_script = templatefile("${path.module}/templates/startup.sh.tftpl", {
    app_name    = var.name_prefix
    app_port    = var.app_port
    app_version = var.app_version
    environment = var.environment
    team        = var.team
  })
}
