# Version manifest

Record the exact versions used in rehearsal and in class. Learners should
match the Terraform minor version and let `terraform init` select the provider
within the constraint in `versions.tf`.

| Component | Constraint in code | Verified at authoring (29 Oct 2026) | Rehearsal value (fill in) |
| --- | --- | --- | --- |
| Terraform CLI | `>= 1.11` in `versions.tf` | 1.15.x stable line (1.15.9 released 19 Aug 2026) | |
| Google provider (`hashicorp/google`) | `~> 8.0` | 8.x line (8.9.0 current at authoring) | |
| Google Cloud CLI (`gcloud`) | current stable | current stable | |
| jq | 1.6 or later | 1.7.x | |
| Graphviz (`dot`) | optional, for D03 graph rendering | any | |

## Why these constraints

- `required_version = ">= 1.11"` guarantees ephemeral values (1.10) and
  write-only arguments (1.11), both used in M06 / D06. Terraform 1.15 is the
  current stable line; 1.16 is in pre-release at authoring time.
- `version = "~> 8.0"` tracks the current Google provider major line (8.x) and
  blocks an unreviewed jump to 9.0. Provider 8.0 is a major release; the
  course configuration contains none of the removed resources.
- Provider 8.0 made `secret_data_wo_version` a string and required whenever
  `secret_data_wo` is set on `google_secret_manager_secret_version`. The D06
  write-only example uses the 8.x form.

## How to check

```bash
terraform version
gcloud version
jq --version
```

Run `scripts/preflight.sh` to capture all of these into an evidence file.
