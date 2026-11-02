# Part B uses these two outputs. Part C adds the rest.

output "instance_name" {
  description = "Name of the ledgerlite Compute Engine instance."
  value       = google_compute_instance.app.name
}

output "instance_zone" {
  description = "Zone of the ledgerlite instance."
  value       = google_compute_instance.app.zone
}
