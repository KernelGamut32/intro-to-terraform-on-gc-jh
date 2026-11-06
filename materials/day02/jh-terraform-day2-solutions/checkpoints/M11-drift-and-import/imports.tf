# L06 Part 2 (M11): adopt a firewall rule that Network Engineering created
# outside Terraform under ticket NET-1182.
#
# The import block is configuration: it is reviewed in a plan like any other
# change. The id uses the format documented by the provider for this
# resource type: projects/PROJECT/global/firewalls/NAME

import {
  to = google_compute_firewall.health_check
  id = "projects/${var.project_id}/global/firewalls/${var.name_prefix}-allow-health-check"
}

resource "google_compute_firewall" "health_check" {
  name        = "${var.name_prefix}-allow-health-check"
  description = "Allow Google Cloud health check probes to the app port. Created by Network Engineering under NET-1182."
  network     = google_compute_network.main.id
  direction   = "INGRESS"
  priority    = 900

  allow {
    protocol = "tcp"
    ports    = [tostring(var.app_port)]
  }

  # Google Cloud health check probe ranges.
  source_ranges = ["35.191.0.0/16", "130.211.0.0/22"]
  target_tags   = ["${var.name_prefix}-app"]
}
