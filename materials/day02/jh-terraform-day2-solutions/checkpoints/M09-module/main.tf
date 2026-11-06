# ledgerlite environment, parameterized (checkpoint: end of M09, L05, module extracted).

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

  # M07: one dynamic block generates an allow block for each rule in
  # var.allow_rules. With the default value the generated block is identical
  # to the literal block it replaced, so the refactor plan is empty.
  dynamic "allow" {
    for_each = var.allow_rules
    content {
      protocol = allow.value.protocol
      ports    = allow.value.ports
    }
  }

  source_ranges = var.iap_source_ranges
  target_tags   = ["${var.name_prefix}-app"]
}

# ---------------------------------------------------------------------------
# Compute Engine instance (app_instance module)
# ---------------------------------------------------------------------------

# M09: the instance now lives in a child module. The root passes inputs in
# and reads results back through the module's outputs.
module "app" {
  source = "./modules/app_instance"

  name                  = "${var.name_prefix}-app"
  zone                  = var.zone
  subnetwork            = google_compute_subnetwork.app.id
  boot_image            = data.google_compute_image.app.self_link
  service_account_email = var.app_service_account_email
  machine_type          = var.machine_type
  network_tags          = ["${var.name_prefix}-app"]
  labels                = local.common_labels

  app = {
    name        = var.name_prefix
    port        = var.app_port
    version     = var.app_version
    environment = var.environment
    team        = var.team
  }
}
