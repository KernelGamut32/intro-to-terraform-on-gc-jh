# Change records for L06 Part 1

Platform Services keeps a record for every approved change. Use these
records to decide what to do about each difference you find on
`ledgerlite-app`.

---

## CHG-3187: cost center re-mapping (APPROVED)

| Field | Value |
| --- | --- |
| Requested by | Finance Operations, Marisol Vance |
| Approved by | Change Advisory Board, at this week's meeting |
| Scope | All `ledgerlite` instances in development projects |
| Change | Label `cost_center` moves from `cc-4410` to `cc-4477` |
| How it was made | Bulk label update with `gcloud`, outside Terraform, this afternoon |
| Follow-up owner | Each owning team must make its Terraform configuration agree |

---

## PATCH-OPS notice 2026-44: patch group enrollment (INFORMATIONAL)

| Field | Value |
| --- | --- |
| Issued by | Infrastructure Patch Operations, Andre Kowalczyk |
| Scope | Every Linux instance in lab and development projects |
| Change | The patch scheduler adds the label `patch_group` and maintains its value |
| Current value | `weekly-a` |
| Owner of the label | Patch Operations. Owning teams must not set or remove it |

---

## No record found

Search the change system for any other difference you find. If a
difference has no approved record, treat it as unapproved.

---

## Decision guide

| The difference is | Decision | How |
| --- | --- | --- |
| Approved, and Terraform should own the new value | Accept into configuration | Edit the configuration to match, then confirm the plan no longer proposes to undo it |
| Owned by another team or tool, on an attribute this configuration does not manage | Accept into state only | Reviewed `terraform apply -refresh-only`; no configuration change |
| Unapproved | Restore | Apply a reviewed plan that returns the infrastructure to the configuration |
