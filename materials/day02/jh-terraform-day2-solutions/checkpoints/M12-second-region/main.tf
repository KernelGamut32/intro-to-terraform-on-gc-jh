# ledgerlite second placement (checkpoint: end of M12, L07).
#
# Shared: the VPC network and its firewall rules (global resources owned by
# the primary root). Regional: the subnet and the instance created here.

# ---------------------------------------------------------------------------
# Shared foundation, read from the primary root's published outputs.
# Only root-level outputs are visible through remote state.
# ---------------------------------------------------------------------------

data "terraform_remote_state" "primary" {
  backend = "gcs"

  config = {
    bucket = var.state_bucket
    prefix = var.primary_state_prefix
  }
}

# The image is not managed by any Terraform configuration, so a data source
# is the right way to look it up.
data "google_compute_image" "app" {
  family  = var.image_family
  project = var.image_project
}

locals {
  shared_network = data.terraform_remote_state.primary.outputs.network_name
  primary_region = data.terraform_remote_state.primary.outputs.inventory.region

  # The primary root publishes the network NAME. The full resource ID is
  # built here so the subnet reference is unambiguous.
  shared_network_id = "projects/${var.project_id}/global/networks/${local.shared_network}"

  common_labels = merge(var.labels, {
    app         = var.name_prefix
    environment = var.environment
    team        = var.team
    managed_by  = "terraform"
    placement   = var.region
  })
}

# ---------------------------------------------------------------------------
# Regional network: a subnet for this region inside the shared VPC
# ---------------------------------------------------------------------------

resource "google_compute_subnetwork" "app" {
  name                     = "${var.name_prefix}-subnet-${var.region}"
  ip_cidr_range            = var.subnet_cidr
  region                   = var.region
  network                  = local.shared_network_id
  private_ip_google_access = true

  lifecycle {
    # A precondition fails the plan with a clear message when an assumption
    # does not hold. This one stops a second placement in the primary region.
    precondition {
      condition     = var.region != local.primary_region
      error_message = "The second placement must use a different region from the primary deployment."
    }
  }
}

# ---------------------------------------------------------------------------
# The same module the primary root uses, called with regional inputs
# ---------------------------------------------------------------------------

module "app" {
  source = "../L01-build-and-parameterize/modules/app_instance"

  name                  = "${var.name_prefix}-app-${var.region}"
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
