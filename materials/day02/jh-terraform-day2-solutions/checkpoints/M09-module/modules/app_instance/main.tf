# app_instance: one ledgerlite application instance.
#
# The pattern this module owns: no external IP address, a boot disk from the
# image the caller selects, the runtime identity the caller supplies, and a
# startup page rendered from the module's own template.

resource "google_compute_instance" "this" {
  name         = var.name
  machine_type = var.machine_type
  zone         = var.zone
  tags         = var.network_tags
  labels       = var.labels

  boot_disk {
    initialize_params {
      image = var.boot_image
      size  = 10
      type  = "pd-balanced"
    }
  }

  network_interface {
    # No access_config block: the instance receives no external IP address.
    subnetwork = var.subnetwork
  }

  service_account {
    email  = var.service_account_email
    scopes = ["cloud-platform"]
  }

  # path.module is the directory of THIS module, so the template travels
  # with the module wherever it is called from. A change to the rendered
  # script forces replacement of the instance.
  metadata_startup_script = templatefile("${path.module}/templates/startup.sh.tftpl", {
    app_name    = var.app.name
    app_port    = var.app.port
    app_version = var.app.version
    environment = var.app.environment
    team        = var.app.team
  })
}
