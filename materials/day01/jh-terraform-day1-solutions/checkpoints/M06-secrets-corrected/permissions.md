# Corrected permission design

| Identity | Role | Scope | Why |
| --- | --- | --- | --- |
| `tf-runner@jh-tf-lab-07.iam.gserviceaccount.com` | `roles/compute.networkAdmin` | project | VPC and subnet |
| same | `roles/compute.securityAdmin` | project | Firewall rule only |
| same | `roles/compute.instanceAdmin.v1` | project | Instance and disk |
| same | `roles/iam.serviceAccountUser` | runtime service account `ledgerlite-app@...` | Attach that identity to the instance |
| same (backend job) | `roles/storage.objectAdmin` | bucket `jh-tf-state-lab-07-4f2a` | Read, write, and lock state |
| same | `roles/secretmanager.admin` | secret `ledgerlite-billing-api-key` only, if the runner manages the secret container; otherwise none | Manage the container, never read versions |
| `ledgerlite-app@jh-tf-lab-07.iam.gserviceaccount.com` | `roles/secretmanager.secretAccessor` | secret `ledgerlite-billing-api-key` | Read the value at startup |
| `user:dana.whitfield@jhlabs.example` | `roles/iap.tunnelResourceAccessor`, `roles/compute.viewer` | project | Verify through IAP; no write access |
| `group:platform-services-all@jhlabs.example` | none on the state bucket | | State is not a team-wide artifact |

Removed: `roles/owner` and `roles/editor` on the project for every identity
above.

## Artifacts that need controlled access

| Artifact | Why | Owner |
| --- | --- | --- |
| State object in `gs://jh-tf-state-lab-07-4f2a/labs/lab-07/` | Holds every attribute Terraform recorded, including any secret that passed through configuration | Platform Services (bucket IAM) |
| Saved plan files (`tfplan`) | Contain planned values in plaintext; attach to a PR only through a controlled pipeline store | CI pipeline owner |
| `terraform output -json` | Carries every output, including any marked sensitive | Whoever runs it; never paste into chat |
| `TF_LOG=TRACE` output | Can include request and response bodies | Person diagnosing; redact before sharing |
| `.terraform/` directory | May cache backend configuration and credentials-adjacent settings | Never shared |
| Instance metadata | Readable by anyone with `compute.instances.get` | Carry names, not values |
