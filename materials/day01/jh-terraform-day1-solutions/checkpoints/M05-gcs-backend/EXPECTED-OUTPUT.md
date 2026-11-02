# Expected output (L02)

## terraform init -migrate-state

```
Initializing the backend...
Do you want to copy existing state to the new backend?
  Pre-existing state was found while migrating the previous "local" backend to the
  newly configured "gcs" backend. No existing state was found in the newly
  configured "gcs" backend. Do you want to copy this state to the new "gcs"
  backend? Enter "yes" to copy and "no" to start with an empty state.

  Enter a value: yes

Successfully configured the backend "gcs"! Terraform will automatically
use this backend unless the backend configuration changes.
```

## Remote object

```
$ gcloud storage ls gs://jh-tf-state-lab-07-4f2a/labs/lab-07/
gs://jh-tf-state-lab-07-4f2a/labs/lab-07/default.tfstate
```

The object is named `default.tfstate` because the default CLI workspace is in
use (M10 on Day 2 covers workspaces).

## State identity

```
$ terraform state pull | jq '{serial, lineage, resources: (.resources | length)}'
{
  "serial": 7,
  "lineage": "3b1a9d2e-6c4f-4a8e-9f10-2d7c5e8b4a61",
  "resources": 5
}
```

Serial and lineage values differ per learner. `resources` is 5: four managed
resources plus the `google_compute_image` data source.

## Lock contention

```
Error: Error acquiring the state lock

Error message: writing "gs://jh-tf-state-lab-07-4f2a/labs/lab-07/default.tflock" failed:
googleapi: Error 412: At least one of the pre-conditions you specified did not hold., conditionNotMet
Lock Info:
  ID:        1761790112345678
  Path:      gs://jh-tf-state-lab-07-4f2a/labs/lab-07/default.tflock
  Operation: OperationTypeApply
  Who:       learner07@jhlabs-ws-07
  Version:   1.15.9
  Created:   2026-10-30 14:08:32.11 +0000 UTC
```

The exact wording varies by Terraform version; the key facts are the lock
object path (`default.tflock`), the operation, and who holds it.
