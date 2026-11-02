# Current permission design (as reviewed)

| Identity | Granted role | Scope | Used for |
| --- | --- | --- | --- |
| `tf-runner@jh-tf-lab-07.iam.gserviceaccount.com` | `roles/owner` | project `jh-tf-lab-07` | Runs terraform plan and apply |
| `ledgerlite-app@jh-tf-lab-07.iam.gserviceaccount.com` | `roles/editor` | project `jh-tf-lab-07` | Attached to the instance; reads one secret |
| `group:platform-services-all@jhlabs.example` | `roles/storage.admin` | project `jh-tf-lab-07` | Reads and writes state in `gs://jh-tf-state-lab-07-4f2a` |
| `user:dana.whitfield@jhlabs.example` | `roles/owner` | project `jh-tf-lab-07` | "Just in case" |

Artifacts the team shares today:

- Saved plan files attached to pull requests as downloadable artifacts.
- `terraform output -json` pasted into a team chat channel after each apply.
- `TF_LOG=TRACE` output attached to support tickets.
- The `.terraform/` directory zipped and shared to "speed up init".
