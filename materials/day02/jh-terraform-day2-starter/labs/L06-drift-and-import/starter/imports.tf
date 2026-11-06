# L06 Part 2 (M11): adopt a firewall rule that Network Engineering created
# outside Terraform under ticket NET-1182.
#
# Copy this file to the ledgerlite root:
#   cp ../L06-drift-and-import/starter/imports.tf imports.tf
#
# The import block is configuration: it is reviewed in a plan like any other
# change.

import {
  # The address the firewall rule will have in this configuration.
  to = google_compute_firewall.health_check

  # TODO-M11 (1): the provider's import ID for a firewall rule has the form
  #   projects/PROJECT/global/firewalls/NAME
  # Build it from var.project_id and var.name_prefix. The rule is named
  # "<name_prefix>-allow-health-check".
  id = "TODO"
}

resource "google_compute_firewall" "health_check" {
  name      = "${var.name_prefix}-allow-health-check"
  network   = google_compute_network.main.id
  direction = "INGRESS"

  # TODO-M11 (2): describe the rule that already exists. Read it first:
  #   gcloud compute firewall-rules describe NAME --format=yaml
  # Then complete the arguments below, and add any argument that is missing,
  # until the import plan reports 0 to change.
  allow {
    protocol = "tcp"
    ports    = ["TODO"]
  }

  source_ranges = ["TODO"]
  target_tags   = ["TODO"]
}
