# Version manifest for Day 2

Use the same Terraform and provider versions you used on Day 1. The lab
steps work on Terraform 1.11 or later. A few optional callouts need a newer
release and are marked in the guide.

| Component | Constraint in code | Verified at authoring (5 Nov 2026) | Rehearsal value (fill in) |
| --- | --- | --- | --- |
| Terraform CLI | `>= 1.11` in `versions.tf` | 1.17.1 is the current release (28 Oct 2026). 1.17.0 shipped 21 Oct 2026 and 1.16.0 shipped 26 Aug 2026 | |
| Google provider (`hashicorp/google`) | `~> 8.0` in root modules, `>= 8.0` in the reusable module | 8.10.0 is the newest 8.x tag (3 Nov 2026) | |
| Google Cloud CLI (`gcloud`) | current stable | current stable | |
| jq | 1.6 or later | 1.7.x | |

## Features used today and the release that introduced them

| Feature | Where | Needs |
| --- | --- | --- |
| `moved` block | L05 | Terraform 1.1 |
| `optional()` object attributes | L04 | Terraform 1.3 |
| `import` block | L06 | Terraform 1.5 |
| Expressions in the `id` of an `import` block | L06 | Terraform 1.6 |
| `removed` block | Discussion in M09 and M11 | Terraform 1.7 |
| Provider-defined functions such as `provider::google::region_from_zone` | L04 | Terraform 1.8 |
| Validation that references another variable | L04 | Terraform 1.9 |
| `identity` in an `import` block | Optional callout in L06 | Terraform 1.12 and a provider that publishes resource identity |
| `terraform console -scope=module.app` | Optional callout in L05 | Terraform 1.16 |
| `import` blocks inside child modules | Discussion in M11 | Terraform 1.16 |
| `-minimal-refresh` planning option | Discussion in M11 | Terraform 1.17 |

## Why the constraints differ between a root and a module

- A root module pins the provider to the current major line with `~> 8.0`
  so a jump to 9.0 is a reviewed change.
- A reusable module declares only the minimum it needs with `>= 8.0` and
  leaves the final choice to the root that calls it.

## How to check

```bash
terraform version
gcloud version
jq --version
```

`scripts/day2-preflight.sh` records the Terraform and provider versions in an evidence file.
