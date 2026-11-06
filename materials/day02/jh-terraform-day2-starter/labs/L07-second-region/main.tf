# ledgerlite second placement.
#
# Shared: the VPC network and its firewall rules (global resources owned by
# the primary root). Regional: the subnet and the instance created here.
#
# Complete every line marked TODO-M12. Run terraform fmt and
# terraform validate after each change.

# ---------------------------------------------------------------------------
# Shared foundation, read from the primary root's published outputs.
# Only root-level outputs are visible through remote state.
# ---------------------------------------------------------------------------

data "terraform_remote_state" "primary" {
  backend = "gcs"

  config = {
    # TODO-M12 (1): where the primary root keeps its state. Use the two
    # input variables declared for this purpose in variables.tf.
    bucket = "TODO"
    prefix = "TODO"
  }
}

# The image is not managed by any Terraform configuration, so a data source
# is the right way to look it up.
data "google_compute_image" "app" {
  family  = var.image_family
  project = var.image_project
}

locals {
  # TODO-M12 (2): the name of the shared network, taken from the primary
  # root's `network_name` output:
  #   data.terraform_remote_state.primary.outputs.<output name>
  shared_network = "TODO"

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
  # TODO-M12 (3): a subnet for THIS region. Follow the primary root's naming
  # pattern "<name_prefix>-subnet-<region>" and use the inputs for the CIDR
  # range and the region.
  name          = "TODO"
  ip_cidr_range = "TODO"
  region        = "TODO"

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
  # TODO-M12 (4): reuse the module you extracted in L05. It lives inside the
  # primary root; write the path relative to THIS directory.
  source = "TODO"

  # TODO-M12 (5): the regional inputs. Names must stay unique across
  # placements: use "<name_prefix>-app-<region>".
  name       = "TODO"
  zone       = "TODO"
  subnetwork = "TODO"

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
