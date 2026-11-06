# L05 (M09): this block replaces the whole
#   resource "google_compute_instance" "app" { ... }
# block in main.tf of the ledgerlite root. Paste it in the same place.

# M09: the instance now lives in a child module. The root passes inputs in
# and reads results back through the module's outputs.
module "app" {
  # TODO-M09 (6): the path of the module directory inside this root.
  source = "TODO"

  # TODO-M09 (7): pass every input. Use exactly the expressions the resource
  # block used, so that nothing about the running instance changes.
  #
  #   resource argument                         module input
  #   name                                      name
  #   zone                                      zone
  #   network_interface.subnetwork              subnetwork
  #   boot_disk.initialize_params.image         boot_image
  #   service_account.email                     service_account_email
  #   machine_type                              machine_type
  #   tags                                      network_tags
  #   labels                                    labels
  #   the five templatefile() values            app = { name, port, version, environment, team }
  name                  = "TODO"
  zone                  = "TODO"
  subnetwork            = "TODO"
  boot_image            = "TODO"
  service_account_email = "TODO"
  machine_type          = "TODO"
  network_tags          = ["TODO"]
  labels                = {}

  app = {
    name        = "TODO"
    port        = 0
    version     = "TODO"
    environment = "TODO"
    team        = "TODO"
  }
}
