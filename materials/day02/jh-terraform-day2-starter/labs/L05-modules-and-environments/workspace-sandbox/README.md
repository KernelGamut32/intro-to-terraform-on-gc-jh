# Workspace sandbox

A disposable configuration for the M10 workspace check. Local state only.

```
terraform init
terraform workspace show
terraform workspace new scratch
terraform apply -auto-approve
terraform workspace select default
terraform plan
terraform workspace list
```

What to notice:

- `scratch` and `default` are two states for one configuration and one backend.
- The plan in `default` proposes to create the marker. It does not see the
  object recorded in `scratch`, which still exists.
- With local state the two states are files under `terraform.tfstate.d/`.
  With your GCS backend they would be two objects under the same prefix in
  the same bucket, readable by the same identities.

Clean up:

```
terraform workspace select scratch
terraform destroy -auto-approve
terraform workspace select default
terraform workspace delete scratch
```

`-auto-approve` is acceptable here only because this sandbox manages nothing
real. Do not use it in the ledgerlite root.
