# Identity-to-permission worksheet (L03)

## Part 1: Where could the secret still be?

For each location, write YES or NO and one sentence of reasoning.

| Location | Could the billing API key appear here after the flawed config is applied? | Why |
| --- | --- | --- |
| Source code (`variables.tf`, `terraform.tfvars`) | | |
| Terraform state in the GCS bucket | | |
| A saved plan file (`tfplan`) | | |
| `terraform output -json` | | |
| `TF_LOG=TRACE` output | | |
| Instance metadata (console or `gcloud compute instances describe`) | | |
| Secret Manager | | |

## Part 2: Give each identity only its job

| Identity | Job | Narrowest role(s) | Narrowest scope |
| --- | --- | --- | --- |
| Terraform runner | Create the VPC, subnet, firewall rule, instance; attach the runtime identity | | |
| Backend user (same runner, different job) | Read and write the state object; acquire the lock | | |
| Runtime service account | Read one secret at startup | | |
| Human operator | Review plans, open an IAP tunnel to verify | | |

## Part 3: Which artifacts need controlled access?

List every artifact that must be access-controlled, and name an owner for each.

| Artifact | Why it needs control | Owner |
| --- | --- | --- |
| | | |
| | | |
| | | |
| | | |
