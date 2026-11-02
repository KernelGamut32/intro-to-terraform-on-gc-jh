output "instance_name" {
  description = "Name of the application instance."
  value       = google_compute_instance.app.name
}

output "instance_zone" {
  description = "Zone of the application instance."
  value       = google_compute_instance.app.zone
}

output "internal_ip" {
  description = "Internal IP address of the application instance."
  value       = google_compute_instance.app.network_interface[0].network_ip
}

output "network_name" {
  description = "Name of the VPC network."
  value       = google_compute_network.main.name
}

output "subnet_name" {
  description = "Name of the application subnet."
  value       = google_compute_subnetwork.app.name
}

output "image_used" {
  description = "Exact image resolved from the family at plan time."
  value       = data.google_compute_image.app.name
}

output "ssh_command" {
  description = "Connect through IAP TCP forwarding; no external IP is needed."
  value       = "gcloud compute ssh ${google_compute_instance.app.name} --zone ${var.zone} --project ${var.project_id} --tunnel-through-iap"
}
