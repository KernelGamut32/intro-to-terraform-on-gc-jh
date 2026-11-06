# Expected results: L05 Part A (M09)

All output is representative. Identifiers and hidden-attribute counts vary.

## The unsafe plan (module call in place, no moved block)

Read it. Do not apply it.

```
  # google_compute_instance.app will be destroyed
  # (because google_compute_instance.app is not in configuration)
  - resource "google_compute_instance" "app" {
      - name         = "ledgerlite-app" -> null
      - machine_type = "e2-small" -> null
        # (other attributes)
    }

  # module.app.google_compute_instance.this will be created
  + resource "google_compute_instance" "this" {
      + name         = "ledgerlite-app"
      + machine_type = "e2-small"
        # (other attributes)
    }

Plan: 1 to add, 0 to change, 1 to destroy.
```

Nothing about the instance changed. Only its address did, and by default
Terraform treats a new address as a new object.

## The corrected plan (moved.tf added)

```
Terraform will perform the following actions:

  # google_compute_instance.app has moved to module.app.google_compute_instance.this
    resource "google_compute_instance" "this" {
        id                      = "projects/jh-tf-lab-07/zones/us-central1-a/instances/ledgerlite-app"
        name                    = "ledgerlite-app"
        tags                    = [
            "ledgerlite-app",
        ]
        # (unchanged attributes hidden)

        # (unchanged blocks hidden)
    }

Plan: 0 to add, 0 to change, 0 to destroy.
```

Apply it so the new address is recorded in state:

```
Apply complete! Resources: 0 added, 0 changed, 0 destroyed.
```

```
$ terraform state list
data.google_compute_image.app
google_compute_firewall.allow_iap
google_compute_network.main
google_compute_subnetwork.app
module.app.google_compute_instance.this
```

The next plan is empty, and the outputs are unchanged:

```
$ terraform output instance_name
"ledgerlite-app"
```

## If the corrected plan still shows a replacement

| What the plan shows | Cause | Fix |
| --- | --- | --- |
| `~ metadata_startup_script ... # forces replacement` | The template in the module is not byte-identical to the one the instance was created from, or an `app` value differs | Move the learner's own `templates/startup.sh.tftpl` into `modules/app_instance/templates/`. Compare the five `app` values with the old `templatefile()` call |
| `~ name ... # forces replacement` | `name` passed to the module is not `"${var.name_prefix}-app"` | Fix the module call |
| `~ labels` update in place | `labels` not passed, or passed as something other than `local.common_labels` | Fix the module call |
| `~ tags` update in place | `network_tags` not passed as `["${var.name_prefix}-app"]` | Fix the module call |
| `google_compute_instance.app will be destroyed` and `module.app... will be created` | `moved.tf` is not in the root, or the `to` address does not match the module call name and resource name | Copy `moved.tf`; check `module "app"` and `resource "google_compute_instance" "this"` |

## Optional callout: console scoped to the module (Terraform 1.16 or later)

```
$ terraform console -scope=module.app
> var.app
{
  "environment" = "dev"
  "name" = "ledgerlite"
  "port" = 8080
  "team" = "platform-services"
  "version" = "1.0.0"
}
> google_compute_instance.this.name
"ledgerlite-app"
```
