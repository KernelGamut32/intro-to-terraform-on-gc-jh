# L02: Migrate to GCS state (M05)

You will move the state for your L01 deployment from the local
`terraform.tfstate` file into your assigned bucket and prefix.

1. Confirm the bucket exists and has Object Versioning enabled.
2. Copy `backend.tf.example` into `labs/L01-build-and-parameterize/backend.tf`
   and set your bucket and prefix.
3. Run `terraform init -migrate-state` inside the L01 directory.
4. Verify the remote object, run `terraform state list`, and run a plan.

Follow `migration-checklist.md` step by step and tick each line.
