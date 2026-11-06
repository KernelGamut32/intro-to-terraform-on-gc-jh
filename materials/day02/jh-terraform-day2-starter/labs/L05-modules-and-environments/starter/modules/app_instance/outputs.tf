# Outputs are the only way a caller can read anything from this module.
# Return identifiers; do not make callers reach inside.

output "instance_name" {
  description = "Name of the instance."
  value       = google_compute_instance.this.name
}

output "instance_zone" {
  description = "Zone of the instance."
  value       = google_compute_instance.this.zone
}

# TODO-M09 (5): add three more outputs. The root outputs.tf already reads
# these attributes from the resource, so the expressions are familiar:
#   instance_id    the server-assigned numeric ID   (attribute: instance_id)
#   internal_ip    the internal IP address          (attribute: network_interface[0].network_ip)
#   machine_type   the machine type                 (attribute: machine_type)

output "self_link" {
  description = "Self link of the instance."
  value       = google_compute_instance.this.self_link
}
