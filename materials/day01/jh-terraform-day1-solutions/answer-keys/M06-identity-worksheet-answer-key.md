# M06 identity-to-permission worksheet: answer key

## Part 1: Where could the secret still be?

| Location | Answer | Why |
| --- | --- | --- |
| Source code | YES | Default value in `variables.tf` and literal in `terraform.tfvars` |
| Terraform state | YES | `secret_data`, `metadata`, and both outputs are recorded in state as plaintext; `sensitive = true` only affects display |
| Saved plan file | YES | The plan records planned values, including the secret |
| `terraform output -json` | YES | JSON output includes sensitive outputs in plaintext |
| `TF_LOG=TRACE` | YES (possible) | Trace logging can include request bodies sent to the Secret Manager and Compute APIs |
| Instance metadata | YES | `metadata` keys are readable by anyone with `compute.instances.get` |
| Secret Manager | YES, and that is the only place it should be | The secret belongs in Secret Manager; the problem is every other copy |

Key statement for the evidence check: a secret manager alone does not keep
state clean. If the value passes through configuration as an ordinary
argument, it is persisted. Only a runtime reference (the workload reads the
value itself), or ephemeral values and write-only arguments where the
provider supports them, keep the value out of state and plans.

## Part 2: Narrowest roles

| Identity | Narrowest roles | Narrowest scope |
| --- | --- | --- |
| Terraform runner | `roles/compute.networkAdmin`, `roles/compute.securityAdmin`, `roles/compute.instanceAdmin.v1` | project |
| Terraform runner (attach identity) | `roles/iam.serviceAccountUser` | the runtime service account only |
| Backend user | `roles/storage.objectAdmin` | the state bucket only |
| Runtime service account | `roles/secretmanager.secretAccessor` | the one secret |
| Human operator | `roles/iap.tunnelResourceAccessor`, `roles/compute.viewer` (plus `roles/compute.osAdminLogin` if OS Login is enforced) | project |

## Part 3: Artifacts

State, saved plans, `output -json`, trace logs, `.terraform/`, instance
metadata, CI artifacts (plan uploads). Each needs an owner and an access
policy; none should be posted to chat or attached to tickets unredacted.

## The two corrections learners must make

1. Remove the embedded secret: delete the defaults and the tfvars entry; pass
   the secret **name**; let the startup script fetch the value using the
   attached identity.
2. Restrict one grant: replace `roles/owner` on the runner with the four
   narrow roles, or replace `roles/editor` on the runtime identity with
   `secretAccessor` on one secret. Either is a full-credit answer.
