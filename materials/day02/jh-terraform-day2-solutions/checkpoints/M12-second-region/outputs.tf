output "instance_name" {
  description = "Name of the second-region application instance."
  value       = module.app.instance_name
}

output "instance_zone" {
  description = "Zone of the second-region application instance."
  value       = module.app.instance_zone
}

output "internal_ip" {
  description = "Internal IP address of the second-region application instance."
  value       = module.app.internal_ip
}

output "subnet_name" {
  description = "Name of the second-region subnet."
  value       = google_compute_subnetwork.app.name
}

output "shared_network" {
  description = "Name of the shared VPC network, as published by the primary root."
  value       = local.shared_network
}

output "app_port" {
  description = "Port the application listens on."
  value       = var.app_port
}

output "project_id" {
  description = "Lab project ID, exposed for helper scripts."
  value       = var.project_id
}

output "tunnel_command" {
  description = "Open an IAP tunnel to the app port, then browse to http://localhost:PORT."
  value       = "gcloud compute start-iap-tunnel ${module.app.instance_name} ${var.app_port} --local-host-port=localhost:${var.app_port} --zone ${var.zone} --project ${var.project_id}"
}

# Handoff inventory for the team that reviews the second placement.
# Identifiers only; nothing here is secret.
output "inventory" {
  description = "Non-secret inventory of the second placement for handoff and audit."
  value = {
    project_id           = var.project_id
    environment          = var.environment
    region               = var.region
    zone                 = var.zone
    network              = local.shared_network
    subnet               = google_compute_subnetwork.app.name
    subnet_cidr          = google_compute_subnetwork.app.ip_cidr_range
    instance             = module.app.instance_name
    instance_id          = module.app.instance_id
    machine_type         = module.app.machine_type
    internal_ip          = module.app.internal_ip
    image                = data.google_compute_image.app.name
    app_version          = var.app_version
    app_port             = var.app_port
    primary_region       = local.primary_region
    primary_state_prefix = var.primary_state_prefix
    managed_by           = "terraform"
  }
}
