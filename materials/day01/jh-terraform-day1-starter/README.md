# Introduction to Terraform on Google Cloud: Day 1 lab repository

Prepared for Jack Henry & Associates. Day 1 covers Terraform foundations and
secure provisioning: a working, parameterized deployment with useful outputs,
a verified GCS backend, and a documented approach to identities and secrets.

The scenario is a fictional internal team, Platform Services, that needs a
repeatable Google Cloud environment for a small Linux application called
`ledgerlite`. The scenario is a teaching example and does not describe any
real architecture.

## Layout

| Path | Purpose |
| --- | --- |
| `labs/L01-build-and-parameterize/` | L01 (M02 to M04): build, deploy, and parameterize the `ledgerlite` environment |
| `labs/L01-build-and-parameterize/disposable/` | A throwaway resource used to practice `terraform destroy` safely |
| `labs/L02-gcs-state/` | L02 (M05): move state to the assigned GCS bucket and prefix |
| `labs/L03-secrets-and-iam/` | L03 (M06): review a flawed configuration and permission design |
| `scripts/` | `preflight.sh`, `inventory.sh`, and `tunnel.sh` helpers |
| `VERSIONS.md` | Tested tool versions and the reason for each constraint |

## Before you start

1. Open the Day 1 Participant Lab Guide and keep it beside the terminal.
2. Run `scripts/preflight.sh LAB_PROJECT_ID` and keep the evidence file it writes.
3. Work only in your assigned lab project. Never create a service account key.

## Day 1 flow

```
M02  verify tools, identity, project  ->  terraform init
M03  complete resource TODOs          ->  fmt, validate, plan -out, apply, verify
M04  parameterize, validate, look up  ->  outputs, inventory, change request CR-2041
M05  add backend "gcs"                ->  init -migrate-state, verify, clean plan
M06  review flawed design             ->  remove secret, restrict grant, list artifacts
```

Keep the main `ledgerlite` deployment running at the end of Day 1. Day 2
builds on it.
