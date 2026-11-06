# Expected results: L04 Part A (M07)

All output is representative. Identifiers and hidden-attribute counts vary.

## A2: typed collection, locals, and outputs

After the type, the two locals, the outputs, and the `instances` value are
in place, `terraform plan` proposes no infrastructure change:

```
Changes to Outputs:
  + allow_rule_summary = [
      + "tcp:22,8080",
    ]
  + instance_plan      = {
      + api   = {
          + labels       = {
              + app         = "ledgerlite"
              + cost_center = "cc-4410"
              + environment = "dev"
              + managed_by  = "terraform"
              + role        = "api"
              + team        = "platform-services"
              + tier        = "service"
            }
          + machine_type = "e2-micro"
          + name         = "ledgerlite-api"
          + region       = "us-central1"
          + zone         = "us-central1-a"
        }
      + batch = {
          + labels       = {
              + app         = "ledgerlite"
              + cost_center = "cc-4410"
              + environment = "dev"
              + managed_by  = "terraform"
              + role        = "batch"
              + schedule    = "nightly"
              + team        = "platform-services"
              + tier        = "jobs"
            }
          + machine_type = "e2-micro"
          + name         = "ledgerlite-batch"
          + region       = "us-central1"
          + zone         = "us-central1-b"
        }
    }
  + small_instances    = [
      + "api",
      + "batch",
    ]

You can apply this plan to save these new output values to the Terraform
state, without changing any real infrastructure.
```

`terraform apply` then ends with:

```
Apply complete! Resources: 0 added, 0 changed, 0 destroyed.
```

The teaching point: a `for` expression produces a value. Seven labels on
`api`, eight on `batch`, and no API call to Compute Engine.

## Type check that must fail

With the explicit type in place, a wrong shape is rejected before any plan:

```
$ terraform plan -var 'instances={api={machine_type="e2-micro"}}'

Error: Invalid value for input variable

The given value is not suitable for var.instances declared at
variables.tf:NNN,1-21: element "api": attributes "labels" and "zone" are
required.
```

With `type = any` the same command fails later and less clearly, inside a
validation rule or a local.

## A3 step 2: the dynamic block refactor

With the default `allow_rules`, the generated block equals the literal block:

```
No changes. Your infrastructure matches the configuration.

Terraform has compared your real infrastructure against your configuration
and found no differences, so no changes are needed.
```

## A3 step 3: CR-2052 item 3, port 9000

After `allow_rules` in `terraform.tfvars` gains the second rule:

```
  # google_compute_firewall.allow_iap will be updated in-place
  ~ resource "google_compute_firewall" "allow_iap" {
        id                      = "projects/jh-tf-lab-07/global/firewalls/ledgerlite-allow-iap"
        name                    = "ledgerlite-allow-iap"
        # (unchanged attributes hidden)

      + allow {
          + ports    = [
              + "9000",
            ]
          + protocol = "tcp"
        }

        # (1 unchanged block hidden)
    }

Plan: 0 to add, 1 to change, 0 to destroy.

Changes to Outputs:
  ~ allow_rule_summary = [
        "tcp:22,8080",
      + "tcp:9000",
    ]
```

One resource, one nested block added, no replacement. Verify:

```
$ gcloud compute firewall-rules describe ledgerlite-allow-iap --format='value(allowed)'
{'IPProtocol': 'tcp', 'ports': ['22', '8080']};{'IPProtocol': 'tcp', 'ports': ['9000']}
```

## Validation that must fail

```
$ terraform plan -var 'allow_rules=[{protocol="tcp",ports=["22"]}]'

Error: Invalid value for variable

allow_rules must include a tcp rule that contains the application port
(var.app_port).
```
