# Expected results: L04 Part B (M08)

All output is representative. Identifiers and hidden-attribute counts vary.

## B1: create the fleet

```
  # google_compute_instance.fleet["api"] will be created
  + resource "google_compute_instance" "fleet" {
      + name         = "ledgerlite-api"
      + machine_type = "e2-micro"
      + zone         = "us-central1-a"
      + labels       = {
          + "app"         = "ledgerlite"
          + "cost_center" = "cc-4410"
          + "environment" = "dev"
          + "managed_by"  = "terraform"
          + "role"        = "api"
          + "team"        = "platform-services"
          + "tier"        = "service"
        }
      # (other attributes, many known after apply)
    }

  # google_compute_instance.fleet["batch"] will be created
  + resource "google_compute_instance" "fleet" {
      + name         = "ledgerlite-batch"
      + machine_type = "e2-micro"
      + zone         = "us-central1-b"
      # (other attributes)
    }

Plan: 2 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + fleet = {
      + api   = {
          + instance_id = (known after apply)
          + internal_ip = (known after apply)
          + name        = "ledgerlite-api"
          + zone        = "us-central1-a"
        }
      + batch = {
          + instance_id = (known after apply)
          + internal_ip = (known after apply)
          + name        = "ledgerlite-batch"
          + zone        = "us-central1-b"
        }
    }
```

After apply:

```
$ terraform state list
data.google_compute_image.app
google_compute_firewall.allow_iap
google_compute_instance.app
google_compute_instance.fleet["api"]
google_compute_instance.fleet["batch"]
google_compute_network.main
google_compute_subnetwork.app
```

## B2: collection changes (plan only, never applied)

Add a key:

```
$ terraform plan -var-file=../L04-collections-and-lifecycle/what-if/add-report.tfvars

  # google_compute_instance.fleet["report"] will be created

Plan: 1 to add, 0 to change, 0 to destroy.
```

Remove a key:

```
$ terraform plan -var-file=../L04-collections-and-lifecycle/what-if/remove-api.tfvars

  # google_compute_instance.fleet["api"] will be destroyed
  # (because key ["api"] is not in for_each map)

Plan: 0 to add, 0 to change, 1 to destroy.
```

In both plans `google_compute_instance.fleet["batch"]` is not mentioned.
Its address did not change, so nothing is proposed for it.

## B3: the designated replacement (applied)

```
$ terraform plan -replace='google_compute_instance.fleet["batch"]' -out=replace.tfplan

  # google_compute_instance.fleet["batch"] will be replaced, as requested
-/+ resource "google_compute_instance" "fleet" {
      ~ creation_timestamp = "2026-11-10T08:02:41.118-08:00" -> (known after apply)
      ~ id                 = "projects/jh-tf-lab-07/zones/us-central1-b/instances/ledgerlite-batch" -> (known after apply)
      ~ instance_id        = "4071935520884716203" -> (known after apply)
        name               = "ledgerlite-batch"
        # (other attributes)
    }

Plan: 1 to add, 0 to change, 1 to destroy.

Changes to Outputs:
  ~ fleet = {
      ~ batch = {
          ~ instance_id = "4071935520884716203" -> (known after apply)
          ~ internal_ip = "10.10.0.4" -> (known after apply)
            # (2 unchanged attributes hidden)
        }
        # (1 unchanged attribute hidden)
    }

$ terraform apply replace.tfplan
google_compute_instance.fleet["batch"]: Destroying... [id=projects/jh-tf-lab-07/zones/us-central1-b/instances/ledgerlite-batch]
google_compute_instance.fleet["batch"]: Destruction complete after 42s
google_compute_instance.fleet["batch"]: Creating...
google_compute_instance.fleet["batch"]: Creation complete after 18s [id=projects/jh-tf-lab-07/zones/us-central1-b/instances/ledgerlite-batch]

Apply complete! Resources: 1 added, 0 changed, 1 destroyed.
```

The order is destroy, then create, because `create_before_destroy` is not
set. The instance ID changes; the name and the address do not. The internal
IP may or may not come back the same.

## B4: update in place or replace? (plan only, never applied)

| Variable file | Summary line | Why |
| --- | --- | --- |
| `labels-only.tfvars` | `Plan: 0 to add, 3 to change, 0 to destroy.` | Labels are updatable in place. Three instances carry the common labels: the app and both fleet instances |
| `version-bump.tfvars` | `Plan: 1 to add, 0 to change, 1 to destroy.` | `app_version` is rendered into `metadata_startup_script`, and the provider replaces the instance when that script changes. The plan marks the attribute `# forces replacement` |
| `resize.tfvars` | `Plan: 0 to add, 1 to change, 0 to destroy.` | `machine_type` is updated in place, but the provider must stop the instance. The apply would fail with an error asking for `allow_stopping_for_update = true`. A clean plan is not a promise that the apply succeeds |

Excerpt for the version bump:

```
  # google_compute_instance.app must be replaced
-/+ resource "google_compute_instance" "app" {
      ~ metadata_startup_script = <<-EOT # forces replacement
            ...
          -     <tr><td>Application version</td><td>1.0.0</td></tr>
          +     <tr><td>Application version</td><td>1.1.0</td></tr>
            ...
        EOT
        name                    = "ledgerlite-app"
        # (other attributes)
    }
```

## B5: retire the fleet (applied)

With `instances = {}` in `terraform.tfvars`:

```
  # google_compute_instance.fleet["api"] will be destroyed
  # (because key ["api"] is not in for_each map)

  # google_compute_instance.fleet["batch"] will be destroyed
  # (because key ["batch"] is not in for_each map)

Plan: 0 to add, 0 to change, 2 to destroy.

Changes to Outputs:
  ~ fleet           = { ... } -> {}
  ~ instance_plan   = { ... } -> {}
  ~ small_instances = [
      - "api",
      - "batch",
    ]
```

`google_compute_instance.app` is not mentioned. After apply, a plan is
empty and `terraform state list` shows four managed resources and the data
source.
