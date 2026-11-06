# Supplied migration mapping for L05 (M09).
#
# Moving a resource into a module changes its address. Without this block
# Terraform would plan to destroy the old address and create the new one.
# With it, Terraform renames the object in state before planning, so the
# existing instance is kept.
#
# Keep this block in place. Removing a moved block later is a breaking
# change for anyone who has not yet applied it.

moved {
  from = google_compute_instance.app
  to   = module.app.google_compute_instance.this
}
