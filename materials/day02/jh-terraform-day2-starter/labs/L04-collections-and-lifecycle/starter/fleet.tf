# The ledgerlite fleet: additional instances described by var.instances.
#
# M07 builds the VALUES in this file. M08 adds the resource that turns each
# entry into a resource instance with a stable key.
#
# Copy this file to the ledgerlite root:
#   cp ../L04-collections-and-lifecycle/starter/fleet.tf fleet.tf

locals {
  # TODO-M07 (2): replace {} with a for expression that produces one entry
  # per key in var.instances. The value for each key is the result of
  # merging, in this order:
  #   local.common_labels, that instance's own labels, and { role = <the key> }
  # Shape:  { for KEY, CFG in COLLECTION : KEY => VALUE }
  instance_labels = {}

  # TODO-M07 (3): replace {} with a for expression that maps each key to the
  # instance name "<name_prefix>-<key>", for example ledgerlite-batch.
  instance_names = {}
}
