# Day 2 solutions and checkpoints

Instructor copy. Each checkpoint under `checkpoints/` is a complete root
configuration that represents the expected state of the ledgerlite root
(`labs/L01-build-and-parameterize/`) at the end of the named module.

| Directory | Represents | Resources in state after apply |
| --- | --- | --- |
| `checkpoints/M07-collections/` | L04 Part A complete: typed `instances`, locals, outputs, `dynamic "allow"`, port 9000 rule | network, subnet, firewall, app instance |
| `checkpoints/M08-fleet/` | L04 Part B with the fleet deployed (`api`, `batch`) | the four above plus `fleet["api"]`, `fleet["batch"]` |
| `checkpoints/M09-module/` | L05 complete: `app_instance` module, `moved.tf`, fleet retired | network, subnet, firewall, `module.app.google_compute_instance.this` |
| `checkpoints/M11-drift-and-import/` | L06 complete: cost center accepted, health check rule imported | the four above plus `google_compute_firewall.health_check` |
| `checkpoints/M12-second-region/` | L07 complete: the second root for `us-east1` | subnet and instance in `us-east1` (own state) |
| `answer-keys/` | Written answers for every worksheet and module check | |

## Using a checkpoint to unblock a learner

1. Copy the checkpoint files over the learner's ledgerlite root.
2. Keep the learner's own `terraform.tfvars`, `backend.tf`, and
   `.terraform.lock.hcl`. Add any new values the checkpoint's
   `terraform.tfvars.example` shows.
3. From `M09-module` onward, **use the learner's own startup template**.
   Move their `templates/startup.sh.tftpl` to
   `modules/app_instance/templates/startup.sh.tftpl` instead of taking the
   copy from the checkpoint. The rendered script must stay byte-identical;
   any difference forces replacement of the instance.
4. Run `terraform init` (module installation), then `terraform plan`.
   Terraform converges the learner's state to the checkpoint. Read the plan
   with the learner before applying: the `moved` block keeps the instance,
   and anything the learner skipped appears as an ordinary create or update.

Resource addresses are stable across checkpoints except for the one
deliberate move in M09, which `moved.tf` records.

## What was verified and what was not

Every `.tf` file in this package was parsed for HCL syntax. The package was
authored without access to a Terraform binary or a Google Cloud project, so
no configuration was run through `terraform validate`, `plan`, or `apply`.
Expected output in the `EXPECTED-*.md` files is representative: it follows
the documented output format and the provider's documented behavior, with
identifiers, counts of hidden attributes, and timings that will differ in
your project. Run the rehearsal checklist in the instructor package once
with the learner role before delivery and replace representative output
with captured output where it differs.
