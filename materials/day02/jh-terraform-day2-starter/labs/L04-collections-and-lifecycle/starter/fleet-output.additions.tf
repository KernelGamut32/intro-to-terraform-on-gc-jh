# Day 2, M08: one entry per fleet instance, keyed the same way as the resource.
output "fleet" {
  description = "Fleet instances by key."
  value = {
    for key, inst in google_compute_instance.fleet : key => {
      name        = inst.name
      zone        = inst.zone
      internal_ip = inst.network_interface[0].network_ip
      instance_id = inst.instance_id
    }
  }
}
