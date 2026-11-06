# Expected results: L06 (M11)

All output is representative. Identifiers, fingerprints, and
hidden-attribute counts vary. The attribute names `labels`,
`terraform_labels`, and `effective_labels` are the provider's documented
label fields.

## Part 1, step 1: read (refresh-only plan)

```
$ terraform plan -refresh-only

Note: Objects have changed outside of Terraform

Terraform detected the following changes made outside of Terraform since
the last "terraform apply" which may have affected this plan:

  # module.app.google_compute_instance.this has changed
  ~ resource "google_compute_instance" "this" {
      ~ effective_labels        = {
          ~ "cost_center"                = "cc-4410" -> "cc-4477"
          ~ "environment"                = "dev" -> "prod"
          + "patch_group"                = "weekly-a"
            # (4 unchanged elements hidden)
        }
        id                      = "projects/jh-tf-lab-07/zones/us-central1-a/instances/ledgerlite-app"
      ~ label_fingerprint       = "kX2pQ9bMvTc=" -> "Zr81mBq0yLw="
      ~ labels                  = {
          ~ "cost_center" = "cc-4410" -> "cc-4477"
          ~ "environment" = "dev" -> "prod"
            # (3 unchanged elements hidden)
        }
        name                    = "ledgerlite-app"
      ~ terraform_labels        = {
          ~ "cost_center"                = "cc-4410" -> "cc-4477"
          ~ "environment"                = "dev" -> "prod"
            # (4 unchanged elements hidden)
        }
        # (unchanged attributes hidden)
    }

This is a refresh-only plan, so Terraform will not take any actions to undo
these. If you were expecting these changes then you can apply this plan to
record the updated values in the Terraform state without changing any
remote objects.
```

Three differences. `patch_group` appears only under `effective_labels`.

## Part 1, step 3: accept reality into state (reviewed refresh-only apply)

```
$ terraform apply -refresh-only

(the same change list)

Would you like to update the Terraform state to reflect these detected changes?
  Terraform will write these changes to the state without modifying any real infrastructure.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes

Apply complete! Resources: 0 added, 0 changed, 0 destroyed.
```

Nothing in Google Cloud changed. Nothing in the configuration changed.
State now records what is really there.

## Part 1, step 4: what does the configuration still disagree with?

```
$ terraform plan

  # module.app.google_compute_instance.this will be updated in-place
  ~ resource "google_compute_instance" "this" {
      ~ effective_labels        = {
          ~ "cost_center"                = "cc-4477" -> "cc-4410"
          ~ "environment"                = "prod" -> "dev"
            # (5 unchanged elements hidden)
        }
        id                      = "projects/jh-tf-lab-07/zones/us-central1-a/instances/ledgerlite-app"
      ~ labels                  = {
          ~ "cost_center" = "cc-4477" -> "cc-4410"
          ~ "environment" = "prod" -> "dev"
            # (3 unchanged elements hidden)
        }
        name                    = "ledgerlite-app"
      ~ terraform_labels        = {
          ~ "cost_center"                = "cc-4477" -> "cc-4410"
          ~ "environment"                = "prod" -> "dev"
            # (4 unchanged elements hidden)
        }
        # (unchanged attributes hidden)
    }

Plan: 0 to add, 1 to change, 0 to destroy.
```

Two differences, not three. The plan would undo the approved cost center
change and the unapproved environment change. It proposes nothing for
`patch_group`: the provider's `labels` argument is non-authoritative and
manages only the keys present in the configuration, so a key added by
another tool is left alone.

If you run a normal plan before the refresh-only apply, Terraform may also
print a note listing the outside changes it detected while refreshing. The
proposed actions are the same two either way.

## Part 1, step 5: accept the approved change in configuration, restore the rest

Edit `terraform.tfvars`:

```hcl
labels = {
  cost_center = "cc-4477"
}
```

```
$ terraform plan -out=restore.tfplan

  # module.app.google_compute_instance.this will be updated in-place
  ~ resource "google_compute_instance" "this" {
      ~ effective_labels        = {
          ~ "environment"                = "prod" -> "dev"
            # (6 unchanged elements hidden)
        }
      ~ labels                  = {
          ~ "environment" = "prod" -> "dev"
            # (4 unchanged elements hidden)
        }
      ~ terraform_labels        = {
          ~ "environment"                = "prod" -> "dev"
            # (5 unchanged elements hidden)
        }
        # (unchanged attributes hidden)
    }

Plan: 0 to add, 1 to change, 0 to destroy.

$ terraform apply restore.tfplan
Apply complete! Resources: 0 added, 1 changed, 0 destroyed.

$ terraform plan
No changes. Your infrastructure matches the configuration.
```

```
$ gcloud compute instances describe ledgerlite-app --zone us-central1-a --format='yaml(labels)'
labels:
  app: ledgerlite
  cost_center: cc-4477
  environment: dev
  goog-terraform-provisioned: 'true'
  managed_by: terraform
  patch_group: weekly-a
  team: platform-services
```

## Part 2: the first import plan (starter block as shipped, id completed)

```
$ terraform plan

  # google_compute_firewall.health_check will be updated in-place
  # (imported from "projects/jh-tf-lab-07/global/firewalls/ledgerlite-allow-health-check")
  ~ resource "google_compute_firewall" "health_check" {
      - description             = "Allow Google Cloud health check probes to the app port. Created by Network Engineering under NET-1182." -> null
        id                      = "projects/jh-tf-lab-07/global/firewalls/ledgerlite-allow-health-check"
        name                    = "ledgerlite-allow-health-check"
      ~ priority                = 900 -> 1000
        # (unchanged attributes hidden)

        # (1 unchanged block hidden)
    }

Plan: 1 to import, 0 to add, 1 to change, 0 to destroy.
```

An import plan shows two things at once: the object that will be adopted,
and what the configuration would then change about it. Here the
configuration would delete the description and move the priority to the
default. Neither is intended, so the configuration is wrong, not the
firewall rule.

## Part 2: the reconciled import plan (applied)

After `description` and `priority = 900` are added:

```
$ terraform plan -out=import.tfplan

  # google_compute_firewall.health_check will be imported
    resource "google_compute_firewall" "health_check" {
        description             = "Allow Google Cloud health check probes to the app port. Created by Network Engineering under NET-1182."
        direction               = "INGRESS"
        id                      = "projects/jh-tf-lab-07/global/firewalls/ledgerlite-allow-health-check"
        name                    = "ledgerlite-allow-health-check"
        priority                = 900
        source_ranges           = [
            "130.211.0.0/22",
            "35.191.0.0/16",
        ]
        target_tags             = [
            "ledgerlite-app",
        ]
        # (other attributes)

        allow {
            ports    = [
                "8080",
            ]
            protocol = "tcp"
        }
    }

Plan: 1 to import, 0 to add, 0 to change, 0 to destroy.

$ terraform apply import.tfplan
google_compute_firewall.health_check: Importing... [id=projects/jh-tf-lab-07/global/firewalls/ledgerlite-allow-health-check]
google_compute_firewall.health_check: Import complete [id=projects/jh-tf-lab-07/global/firewalls/ledgerlite-allow-health-check]

Apply complete! Resources: 1 imported, 0 added, 0 changed, 0 destroyed.

$ terraform plan
No changes. Your infrastructure matches the configuration.

$ terraform state list | grep firewall
google_compute_firewall.allow_iap
google_compute_firewall.health_check
```

## Alternative forms to recognize

Import by resource identity (Terraform 1.12 or later; the Google provider
documents this form for firewall rules):

```hcl
import {
  to = google_compute_firewall.health_check
  identity = {
    name    = "ledgerlite-allow-health-check"
    project = "jh-tf-lab-07"
  }
}
```

Generated configuration (shown in D11). The feature is still labeled
experimental in the Terraform documentation, and the output must be
reviewed and trimmed before it is committed:

```
terraform plan -generate-config-out=generated.tf
```

The CLI route, for recognition only. It writes straight to state, is not
recorded in configuration, and is not previewed in a plan:

```
terraform import google_compute_firewall.health_check projects/jh-tf-lab-07/global/firewalls/ledgerlite-allow-health-check
```
