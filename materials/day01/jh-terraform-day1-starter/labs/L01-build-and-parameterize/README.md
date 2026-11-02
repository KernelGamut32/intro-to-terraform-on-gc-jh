# L01: Build and parameterize the initial deployment

Spans M02, M03, and M04. Work through the parts in order; each part ends with
evidence you keep.

| Part | Module | What you do | Evidence |
| --- | --- | --- | --- |
| A | M02 | Preflight, identity and project verification, repository inspection, `terraform init` | `evidence/preflight-*.txt`, `.terraform.lock.hcl` present |
| B | M03 | Complete the TODO arguments, `fmt`, `validate`, saved plan, `apply`, verify, clean second plan | `evidence/M03-plan.txt`, instance visible in Google Cloud |
| C | M04 | Parameterize settings, add validation and an image lookup, produce outputs, solve CR-2041 | Rejected invalid value, `inventory/dev.md`, clean plan |

Files you will edit: `main.tf`, `variables.tf`, `outputs.tf`, `terraform.tfvars`.

Files you should not need to edit: `versions.tf`, `providers.tf`,
`templates/startup.sh.tftpl`.

The `disposable/` directory is a separate root with its own state. Use it to
practice `terraform destroy` without touching the main deployment.
