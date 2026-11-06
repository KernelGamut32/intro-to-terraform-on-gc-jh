# The ledgerlite fleet: additional instances described by var.instances.
#
# M07 builds the VALUES in this file. M08 adds the resource that turns each
# entry into a resource instance with a stable key.

locals {
  # A for expression in braces with => produces one entry per key in
  # var.instances. merge() works left to right, so an instance label
  # overrides a common label and role always wins.
  instance_labels = {
    for key, cfg in var.instances :
    key => merge(local.common_labels, cfg.labels, { role = key })
  }

  # Names are derived once and reused by the resource and by the outputs.
  instance_names = {
    for key in keys(var.instances) :
    key => "${var.name_prefix}-${key}"
  }
}
