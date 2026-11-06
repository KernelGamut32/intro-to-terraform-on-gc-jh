# L07: Plan a second regional placement

M12. This directory is a **second root configuration**. It has its own
backend prefix, so it has its own state. It never writes to the state of
the ledgerlite root.

```
labs/L01-build-and-parameterize/   primary root   us-central1   prefix labs/lab-NN
labs/L07-second-region/            second root    us-east1      prefix labs/lab-NN/us-east1
```

| Shared (owned by the primary root) | Regional (created here) |
| --- | --- |
| VPC network `ledgerlite-vpc` (global) | Subnet `ledgerlite-subnet-us-east1` |
| Firewall rules (global, selected by network tag) | Instance `ledgerlite-app-us-east1` from the `app_instance` module |

The second root reads the shared network from the primary root's published
outputs through `terraform_remote_state`. It does not look the network up
with a data source, and it does not copy the name by hand.

## Files

| File | Status |
| --- | --- |
| `versions.tf`, `providers.tf`, `variables.tf`, `outputs.tf` | Supplied complete |
| `backend.tf.example` | Copy to `backend.tf` and set your bucket and prefix |
| `terraform.tfvars.example` | Copy to `terraform.tfvars` and set your values |
| `.terraform.lock.hcl` | Copy it from the primary root before `terraform init`, so both roots install the same provider version |
| `main.tf` | Five `TODO-M12` markers |
| `handoff-note.md` | The change explanation another team reviews |

## Required evidence

A reviewed plan that targets `us-east1` and this root's own state, leaves
the primary deployment untouched, and exposes meaningful outputs for
handoff. Applying the plan is an optional extension when quota and time
permit.
