output "instance_name" {
  description = "Name of the application instance."
  value       = module.app.instance_name
}

output "instance_zone" {
  description = "Zone of the application instance."
  value       = module.app.instance_zone
}

output "internal_ip" {
  description = "Internal IP address of the application instance."
  value       = module.app.internal_ip
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
  value       = "gcloud compute ssh ${module.app.instance_name} --zone ${var.zone} --project ${var.project_id} --tunnel-through-iap"
}

output "app_version" {
  description = "Application version rendered into the startup page."
  value       = var.app_version
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

# A single structured output that scripts/inventory.sh turns into a report.
# Contains identifiers only; nothing here is secret.
output "inventory" {
  description = "Non-secret inventory of the deployment for handoff and audit."
  value = {
    project_id    = var.project_id
    environment   = var.environment
    region        = var.region
    zone          = var.zone
    network       = google_compute_network.main.name
    subnet        = google_compute_subnetwork.app.name
    subnet_cidr   = google_compute_subnetwork.app.ip_cidr_range
    instance      = module.app.instance_name
    instance_id   = module.app.instance_id
    machine_type  = module.app.machine_type
    internal_ip   = module.app.internal_ip
    image         = data.google_compute_image.app.name
    app_version   = var.app_version
    app_port      = var.app_port
    firewall_rule = google_compute_firewall.allow_iap.name
    managed_by    = "terraform"
  }
}
# ---------------------------------------------------------------------------
# Day 2, M07: values built from structured inputs. Nothing here creates
# infrastructure; a plan that adds only these shows "Changes to Outputs".
# ---------------------------------------------------------------------------

output "instance_plan" {
  description = "What var.instances asks for, shaped for review. Values only."
  value = {
    for key, cfg in var.instances : key => {
      name         = local.instance_names[key]
      machine_type = cfg.machine_type
      zone         = cfg.zone
      region       = provider::google::region_from_zone(cfg.zone)
      labels       = local.instance_labels[key]
    }
  }
}

output "small_instances" {
  description = "Keys of the instances that use the smallest machine type."
  value       = [for key, cfg in var.instances : key if cfg.machine_type == "e2-micro"]
}

output "allow_rule_summary" {
  description = "Readable summary of the firewall allow rules."
  value       = [for rule in var.allow_rules : "${rule.protocol}:${join(",", coalesce(rule.ports, ["all"]))}"]
}
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
