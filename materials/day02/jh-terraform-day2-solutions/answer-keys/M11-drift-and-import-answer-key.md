# M11 drift and import: answer key

## Part 1 change record

Resource address: `module.app.google_compute_instance.this`

| # | Attribute and key | Configuration | Found | Does a normal plan propose to change it? | Change record | Decision |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | `labels["cost_center"]` | `cc-4410` | `cc-4477` | Yes | CHG-3187, approved | Accept into configuration: set `cost_center = "cc-4477"` in `terraform.tfvars` |
| 2 | `labels["environment"]` | `dev` | `prod` | Yes | None | Restore: apply the reviewed plan that sets it back to `dev` |
| 3 | `effective_labels["patch_group"]` | not managed | `weekly-a` | No | PATCH-OPS notice 2026-44 | Accept into state only: the reviewed refresh-only apply recorded it; no configuration change |

| Line | Expected |
| --- | --- |
| Normal plan after the refresh-only apply, before any edit | `Plan: 0 to add, 1 to change, 0 to destroy.` (one resource, two label keys) |
| Plan applied | `Plan: 0 to add, 1 to change, 0 to destroy.` (one resource, one label key) |
| Final plan | `No changes. Your infrastructure matches the configuration.` |

Why a normal plan proposes nothing for `patch_group`: the Google provider's
`labels` argument is non-authoritative. It manages only the keys written in
the configuration. Labels set by other clients appear in the read-only
`effective_labels` attribute and are never proposed for removal. A
refresh-only plan shows them because it reports every change to recorded
state, not only the ones the configuration disagrees with.

Why the environment label matters although nothing broke: a development
instance labeled `prod` is picked up by anything that selects on that
label, such as billing reports, patch windows, and alert routing.

## Part 2 change record

| Field | Expected |
| --- | --- |
| Existing object | Firewall rule `ledgerlite-allow-health-check` (`google_compute_firewall`) |
| Who created it | Network Engineering, ticket NET-1182 |
| Import ID | `projects/PROJECT_ID/global/firewalls/ledgerlite-allow-health-check` |
| Terraform address | `google_compute_firewall.health_check` |
| First import plan | `Plan: 1 to import, 0 to add, 1 to change, 0 to destroy.` |
| What the first plan wanted to change | Remove the description and set priority back to the default 1000, because the starter block did not declare either |
| Import plan applied | `Plan: 1 to import, 0 to add, 0 to change, 0 to destroy.` |
| Plan after the import | `No changes.` |

Why review an import in a plan: the plan shows the exact object being
adopted and everything the configuration would change about it before
state is written. `terraform import` writes to state immediately; the first
you learn of a mismatch is the next plan, and by then the adoption is not
recorded anywhere in code review.

## Common mistakes

| Mistake | What the learner sees | Coaching |
| --- | --- | --- |
| Ran a normal apply first, "to fix it" | The approved cost center change is undone | The plan said so. Read, then decide per change, then act |
| Set `environment = "prod"` in configuration to make the plan clean | `Error: Invalid value for variable`: `environment must be dev or test.` | The Day 1 validation refused to encode an unapproved value. Ask what would have happened without it: `environment` is rendered into the startup script, so an allowed value such as `test` would replace the instance |
| Tried to add `patch_group` to configuration | Works, but takes ownership of another team's label | Ask who owns the value. Non-authoritative labels exist so two owners can share one resource |
| Import `id` with a wrong project or a mistyped name | `Error: Cannot import non-existent remote object` | The provider accepts three formats (the full path, `PROJECT/NAME`, and `NAME`). The full path is the unambiguous one, and the one to commit |
| Applied the first import plan | Description deleted, priority changed on a rule another team relies on | Reconcile the configuration until the plan shows `0 to change`, then apply |
