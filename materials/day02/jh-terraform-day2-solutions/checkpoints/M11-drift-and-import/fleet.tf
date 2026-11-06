# The ledgerlite fleet: additional instances described by var.instances.
#
# M07 builds the VALUES in this file. M08 adds the resource that turns each
# entry into a resource instance with a stable key.

locals {
  # A for expression in braces with => produces one entry per key in
  # var.instances. merge() works left to right, so an instance label
  # overrides a common label and role always wins.
  instance_labels = {
    for key, cfg in var.instances :
    key => merge(local.common_labels, cfg.labels, { role = key })
  }

  # Names are derived once and reused by the resource and by the outputs.
  instance_names = {
    for key in keys(var.instances) :
    key => "${var.name_prefix}-${key}"
  }
}
# M08: for_each creates one resource instance per map entry. The address of
# each instance contains its key, for example
# google_compute_instance.fleet["batch"], so adding or removing one key never
# changes the address of another instance.
resource "google_compute_instance" "fleet" {
  for_each = var.instances

  name         = local.instance_names[each.key]
  machine_type = each.value.machine_type
  zone         = each.value.zone
  tags         = ["${var.name_prefix}-app"]
  labels       = local.instance_labels[each.key]

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
