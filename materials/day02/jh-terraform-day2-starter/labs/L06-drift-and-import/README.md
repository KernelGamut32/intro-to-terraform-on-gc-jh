# L06: Reconcile drift and import a resource

M11. You work in the ledgerlite root (`labs/L01-build-and-parameterize/`).

| Part | What you do | Evidence |
| --- | --- | --- |
| 1 | Find out what changed on your instance outside Terraform, decide what to do about each change, and carry out the decision | A decision for each change that matches its change record, and a clean plan |
| 2 | Bring an existing firewall rule under Terraform management with an `import` block | One correct address in state, an import plan with nothing to change, and a clean plan afterwards |

## Files

| Path | Use |
| --- | --- |
| `drift-case-cards.md` | The change records you check each difference against |
| `change-record.md` | Where you write your decisions and the plan summary lines |
| `starter/imports.tf` | Starter `import` and `resource` blocks. Copy to the root as `imports.tf` |

Three separate steps, in this order:

```
Read     terraform plan -refresh-only      what changed remotely?
Accept   terraform apply -refresh-only     record reality in state, after review
Desire   edit .tf or .tfvars, plan, apply  change what the configuration asks for
```
