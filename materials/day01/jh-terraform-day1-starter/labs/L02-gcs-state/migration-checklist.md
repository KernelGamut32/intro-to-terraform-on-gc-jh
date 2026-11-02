# State migration checklist (L02)

Work in `labs/L01-build-and-parameterize/`. Tick each line as you complete it.

## Before migration

- [ ] `terraform plan` shows `No changes.` against the local state.
- [ ] `terraform state list` output copied into `evidence/M05-addresses-before.txt`.
- [ ] Bucket exists: `gcloud storage buckets describe gs://BUCKET_NAME --format="value(name)"`
- [ ] Object Versioning is enabled: `gcloud storage buckets describe gs://BUCKET_NAME --format="default(versioning)"`
- [ ] You can list the bucket (backend access): `gcloud storage ls gs://BUCKET_NAME/`
- [ ] A copy of the local state is retained under controlled access:
      `cp terraform.tfstate evidence/terraform.tfstate.pre-migration` (the `evidence/` folder is ignored by Git).

## Migration

- [ ] `backend.tf` created from the example with your bucket and prefix.
- [ ] `terraform init -migrate-state` run and the prompt answered `yes`.
- [ ] Output includes `Successfully configured the backend "gcs"!`

## After migration

- [ ] Remote object exists: `gcloud storage ls gs://BUCKET_NAME/labs/LAB_ID/` shows `default.tfstate`.
- [ ] `terraform state list` shows the same addresses as before (compare with the evidence file).
- [ ] `terraform plan` shows `No changes.`
- [ ] `terraform state pull | jq '{serial, lineage, resources: (.resources | length)}'` recorded.
- [ ] You can explain why two configurations sharing one bucket AND one prefix would collide.

## Optional: observe the lock

Open a second terminal in the same directory.

- Terminal 1: `terraform apply` (stop at the confirmation prompt; do not type yes yet).
- Terminal 2: `terraform plan` (observe `Error: Error acquiring the state lock`).
- Terminal 1: answer `no`.
- Terminal 2: `terraform plan` again (succeeds).
