# M08 plan reading: answer key

## One change request, two plans (count versus for_each)

| # | Question | Answer |
| --- | --- | --- |
| 1 | In plan A, which running instances would be destroyed? | All three. `app[0]` (web) and `app[1]` (api) are replaced, which destroys them, and `app[2]` (worker) is destroyed outright |
| 2 | In plan A, the instance that ends up named `ledgerlite-api` is created at which address? Was that address previously the api instance? | At `app[0]`, which was the web instance. The api instance at `app[1]` is destroyed and recreated as `ledgerlite-worker`. Every surviving name moved to a different address |
| 3 | In plan B, which addresses are not mentioned at all, and what does that tell you? | `app["api"]` and `app["worker"]`. Their keys still exist, so their addresses are unchanged and nothing is proposed for them |
| 4 | Which plan does what was asked? | Plan B: one instance destroyed. Plan A destroys three and creates two to retire one |
| 5 | When is `count` still the right choice? | For identical, interchangeable instances, and for the zero-or-one switch (`count = var.enabled ? 1 : 0`). Use `for_each` when instances have distinct values that an integer cannot express |

Facilitation note: in plan A the apply would also be unsafe to run. The new
`app[0]` named `ledgerlite-api` could be created while the old `app[1]`
with the same name still exists, which Compute Engine rejects.

## Update in place or replace? (L04 B4)

| Change | Symbol | Address | Explanation |
| --- | --- | --- | --- |
| Add a `review` label | `~` | `google_compute_instance.app`, `fleet["api"]`, `fleet["batch"]` | Labels can be changed on a running instance |
| `app_version = "1.1.0"` | `-/+` | `google_compute_instance.app` | The version is rendered into `metadata_startup_script`; the provider replaces the instance when that argument changes, so the script runs again on a fresh boot |
| `machine_type = "e2-medium"` | `~` | `google_compute_instance.app` | Updatable in place, but only on a stopped instance. Without `allow_stopping_for_update = true` the apply fails |

The lesson in the third row: a plan describes intent and provider
knowledge. Some constraints are enforced only when the API call is made.

## Lifecycle decision sheet: suggested answers

| Scenario | Setting | Reason and tradeoff |
| --- | --- | --- |
| A new image appears in the `debian-13` family every few weeks and each one makes the plan replace the instance | Pin the image explicitly, or `ignore_changes = [boot_disk[0].initialize_params[0].image]` | Pinning keeps the decision visible in code. `ignore_changes` stops the churn but also hides a real change to that attribute; patching must then happen through a deliberate `-replace` |
| The state bucket for production must never be destroyed by a mistaken plan | `prevent_destroy = true` | Any plan that would destroy it fails. It does not protect the object if the whole resource block is deleted from the configuration, and it blocks `terraform destroy` |
| A certificate must be replaced with no gap in service | `create_before_destroy = true` | The replacement exists before the original is removed. Both must be able to exist at once, so fixed unique names collide; use a generated suffix |
| An instance group must be recreated whenever its instance template changes | `replace_triggered_by = [the template]` | Ties one resource's replacement to a change in another. Only managed resources can be referenced |
| A second placement must not be created in the primary region | `precondition` | Fails the plan with a clear message before anything is created. It documents an assumption; it does not fix the input |
| A team wants to stop managing a bucket with Terraform but keep the bucket | A `removed` block with `lifecycle { destroy = false }` | Reviewed in a plan, unlike `terraform state rm`. The object keeps existing and Terraform forgets it |
| The app instance uses a fixed name and someone proposes `create_before_destroy` | Do not use it here | The replacement would need the same name while the original still exists; Compute Engine rejects it at apply time |
