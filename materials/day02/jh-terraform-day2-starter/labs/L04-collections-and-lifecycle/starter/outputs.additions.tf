# ---------------------------------------------------------------------------
# Day 2, M07: values built from structured inputs. Nothing here creates
# infrastructure; a plan that adds only these shows "Changes to Outputs".
# Append this file to outputs.tf in the ledgerlite root:
#   cat ../L04-collections-and-lifecycle/starter/outputs.additions.tf >> outputs.tf
# ---------------------------------------------------------------------------

# Supplied complete. It reads the two locals you write in fleet.tf.
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
  # TODO-M07 (4): replace [] with a for expression that returns the KEY of
  # every instance whose machine_type is "e2-micro".
  # Shape:  [for KEY, CFG in COLLECTION : RESULT if CONDITION]
  value = []
}

# Supplied complete.
output "allow_rule_summary" {
  description = "Readable summary of the firewall allow rules."
  value       = [for rule in var.allow_rules : "${rule.protocol}:${join(",", coalesce(rule.ports, ["all"]))}"]
}
