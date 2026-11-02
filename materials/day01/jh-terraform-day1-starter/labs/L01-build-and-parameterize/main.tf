# ledgerlite starter environment: VPC, subnet, narrowly scoped connectivity,
# and one Compute Engine instance with no external IP address.
#
# Part B (M03): complete every line marked TODO-M03. Leave the structure in
# place. Run terraform fmt and terraform validate after each change.

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

  # TODO-M03 (1): reference the network above so Terraform orders creation.
  # Use the exported id attribute of google_compute_network.main.
  network = "TODO"

  # Instances without an external IP can still reach Google APIs.
  private_ip_google_access = true
}

# ---------------------------------------------------------------------------
# Connectivity: only Identity-Aware Proxy TCP forwarding may reach the app.
# 35.235.240.0/20 is the published IAP TCP forwarding source range.
# ---------------------------------------------------------------------------

resource "google_compute_firewall" "allow_iap" {
  name      = "ledgerlite-allow-iap"
  network   = google_compute_network.main.id
  direction = "INGRESS"

  allow {
    protocol = "tcp"
    ports    = ["22", "8080"]
  }

  # TODO-M03 (2): restrict the source to the IAP TCP forwarding range.
  source_ranges = ["TODO"]

  target_tags = ["ledgerlite-app"]
}

# ---------------------------------------------------------------------------
# Compute Engine instance
# ---------------------------------------------------------------------------

resource "google_compute_instance" "app" {
  name = "ledgerlite-app"
  zone = var.zone
  tags = ["ledgerlite-app"]

  # TODO-M03 (3): set an e2-small machine type.
  machine_type = "TODO"

  boot_disk {
    initialize_params {
      # TODO-M03 (4): use the Debian 13 public image family from the
      # debian-cloud project, written as PROJECT/FAMILY.
      image = "TODO"
      size  = 10
      type  = "pd-balanced"
    }
  }

  network_interface {
    # TODO-M03 (5): attach the instance to the subnet declared above using
    # its exported id attribute. Do not add an access_config block: the
    # instance must not receive an external IP address.
    subnetwork = "TODO"
  }

  # The runtime identity attached to the instance. It is NOT the identity
  # that runs Terraform. The runner only needs permission to attach it.
  service_account {
    email  = var.app_service_account_email
    scopes = ["cloud-platform"]
  }

  labels = {
    app        = "ledgerlite"
    managed_by = "terraform"
  }

  # Rendered from a template at plan time. Part C replaces these literals
  # with input variables.
  metadata_startup_script = templatefile("${path.module}/templates/startup.sh.tftpl", {
    app_name    = "ledgerlite"
    app_port    = 8080
    app_version = "0.9.0-starter"
    environment = "lab"
    team        = "platform-services"
  })
}
