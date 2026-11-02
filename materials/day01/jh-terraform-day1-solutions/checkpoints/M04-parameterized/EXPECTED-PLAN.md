# Expected plan (M04 guided part) against the M03 deployment

With the default variable values the names and settings are unchanged, so
the only difference is the image reference. The data source resolves the
family to a specific image self_link, which is the same image the M03 apply
resolved, so the plan is:

```
No changes. Your infrastructure matches the configuration.
```

If a newer image was published in the `debian-13` family between the M03
apply and this plan, the plan shows the boot disk image change, which forces
instance replacement:

```
  # google_compute_instance.app must be replaced
-/+ resource "google_compute_instance" "app" {
      ~ boot_disk {
          ~ initialize_params {
              ~ image = ".../debian-13-trixie-vYYYYMMDD" -> ".../debian-13-trixie-vZZZZZZZZ" # forces replacement
```

Treat that as a teaching moment about image pinning, not as an error. Learners
may apply it; the instance is disposable at this point.

## Validation checks that must fail

```
terraform plan -var 'region=europe-west1'
terraform plan -var 'machine_type=n2-standard-4'
terraform plan -var 'subnet_cidr=10.10.0.0'
terraform plan -var 'zone=us-east1-b'
```

Each must end in an `Error: Invalid value for variable` block that quotes the
`error_message` from `variables.tf`.
