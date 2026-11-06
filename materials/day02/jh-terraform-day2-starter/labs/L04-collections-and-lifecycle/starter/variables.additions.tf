# ---------------------------------------------------------------------------
# Day 2, M07: structured inputs
# Append this file to variables.tf in the ledgerlite root:
#   cat ../L04-collections-and-lifecycle/starter/variables.additions.tf >> variables.tf
# ---------------------------------------------------------------------------

variable "instances" {
  # TODO-M07 (1): replace `any` with an explicit type constraint: a map of
  # objects. Each object has three attributes:
  #   machine_type  a string
  #   zone          a string
  #   labels        a map of strings
  type        = any
  description = "Additional ledgerlite instances keyed by role. The key becomes part of the instance name and of the resource address."
  default     = {}

  validation {
    condition     = alltrue([for key in keys(var.instances) : can(regex("^[a-z][a-z0-9-]{1,14}$", key))])
    error_message = "Each instance key must be 2 to 15 characters: lowercase letters, digits, and hyphens, starting with a letter."
  }

  validation {
    condition     = alltrue([for cfg in values(var.instances) : contains(["e2-micro", "e2-small"], cfg.machine_type)])
    error_message = "Fleet instances must use e2-micro or e2-small in this lab."
  }

  validation {
    # Cross-variable references in validation are supported from Terraform 1.9.
    condition     = alltrue([for cfg in values(var.instances) : startswith(cfg.zone, "${var.region}-")])
    error_message = "Every fleet instance zone must belong to var.region."
  }
}

# Supplied complete. Read it: you use it in the dynamic block.
variable "allow_rules" {
  type = list(object({
    protocol = string
    ports    = optional(list(string))
  }))
  description = "Protocols and ports allowed from var.iap_source_ranges. Leave ports out for protocols that have none, such as icmp."
  default = [
    { protocol = "tcp", ports = ["22", "8080"] },
  ]

  validation {
    # The rule set must keep the application reachable. coalesce() turns a
    # missing ports list into an empty list so contains() always has a list.
    condition = anytrue([
      for rule in var.allow_rules :
      rule.protocol == "tcp" && contains(coalesce(rule.ports, []), tostring(var.app_port))
    ])
    error_message = "allow_rules must include a tcp rule that contains the application port (var.app_port)."
  }
}
