# ---------------------------------------------------------------------------
# Day 2, M08: the fleet resource.
# Append this file to fleet.tf in the ledgerlite root:
#   cat ../L04-collections-and-lifecycle/starter/fleet-resource.additions.tf >> fleet.tf
# ---------------------------------------------------------------------------

resource "google_compute_instance" "fleet" {
  # TODO-M08 (1): add the meta-argument that creates one instance per entry
  # in var.instances, addressed by the map KEY.

  # TODO-M08 (2): the name you built for this key in local.instance_names.
  name = "TODO"

  # TODO-M08 (3): machine type and zone from this entry's object.
  machine_type = "TODO"
  zone         = "TODO"

  tags = ["${var.name_prefix}-app"]

  # TODO-M08 (4): replace {} with the labels you built for this key in
  # local.instance_labels.
  labels = {}

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

  # No service_account block: these instances call no Google Cloud APIs, so
  # they run without an attached identity (least privilege).
}
