# L04: Use collections and lifecycle controls

Spans M07 and M08. You work in the ledgerlite root
(`labs/L01-build-and-parameterize/`). The files in this directory are
snippets you copy into that root, a worksheet, and variable files for
what-if plans.

| Part | Module | What you do | Evidence |
| --- | --- | --- | --- |
| A | M07 | Console experiments, a typed map of objects, `for` expressions, one `dynamic` block | Explicit input type, correct transformed values, an empty refactor plan, one in-place firewall update |
| B | M08 | A fleet created with `for_each`, a collection change you explain before you plan it, one deliberate replacement | Correct address, update and replace distinguished, create and destroy actions justified |

## Files

| Path | Use |
| --- | --- |
| `worksheet.md` | Predict each expression, then check it in `terraform console` |
| `starter/variables.additions.tf` | Append to `variables.tf` in the root (Part A) |
| `starter/fleet.tf` | Copy to the root as `fleet.tf` (Part A) |
| `starter/outputs.additions.tf` | Append to `outputs.tf` in the root (Part A) |
| `starter/instances.tfvars.example` | Append to `terraform.tfvars` in the root (Part A) |
| `starter/allow-rules.tfvars.example` | Append to `terraform.tfvars` in the root (Part A, after the refactor plan is empty) |
| `starter/fleet-resource.additions.tf` | Append to `fleet.tf` in the root (Part B) |
| `starter/fleet-output.additions.tf` | Append to `outputs.tf` in the root (Part B) |
| `what-if/*.tfvars` | Variable files for plans you read but do not apply (Part B) |
| `count-vs-for-each/README.md` | Two plans for the same change request, one with `count` and one with `for_each` |

Every `TODO-M07` and `TODO-M08` marker is a place where you write code.
`TODO-M07 (5)` is the one task without a marker in a file: it is an edit to
`google_compute_firewall.allow_iap` in your own `main.tf`, described in the
lab guide. Run `terraform fmt` and `terraform validate` after each change.
