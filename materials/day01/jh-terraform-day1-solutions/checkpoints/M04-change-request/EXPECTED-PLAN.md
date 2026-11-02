# Expected plan (CR-2041) against the M04 guided deployment

```
Plan: 0 to add, 1 to change, 0 to destroy.
```

`google_compute_instance.app` is updated in place:

```
  # google_compute_instance.app will be updated in-place
  ~ resource "google_compute_instance" "app" {
      ~ labels                  = {
          + "cost_center" = "cc-4410"
          + "environment" = "dev"
          + "team"        = "platform-services"
            # (2 unchanged elements hidden)
        }
      ~ metadata_startup_script = <<-EOT
            ...
          -     <tr><td>Application version</td><td>0.9.0-starter</td></tr>
          +     <tr><td>Application version</td><td>1.0.0</td></tr>
            ...
        EOT
```

Both labels and the startup script are updatable in place on
`google_compute_instance`, so there is no replacement. The new startup
script runs on the next boot, which is why the lab asks for a reset of the
instance to see the new page (`gcloud compute instances reset`).

Firewall and network resources are unchanged.

## Precedence demonstration

```
terraform plan -var-file=test.tfvars
```

shows `environment` changing to `test` and `app_version` to `1.1.0` because
`-var-file` values override `terraform.tfvars`. Do not apply this plan; it is
only a precedence demonstration.

## Validation that must fail

```
terraform plan -var 'app_port=80'
terraform plan -var 'environment=prod'
terraform plan -var 'app_version=latest'
```
