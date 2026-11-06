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

output "instance_id" {
  description = "Server-assigned numeric ID of the instance."
  value       = google_compute_instance.this.instance_id
}

output "internal_ip" {
  description = "Internal IP address of the instance."
  value       = google_compute_instance.this.network_interface[0].network_ip
}

output "machine_type" {
  description = "Machine type of the instance."
  value       = google_compute_instance.this.machine_type
}

output "self_link" {
  description = "Self link of the instance."
  value       = google_compute_instance.this.self_link
}
