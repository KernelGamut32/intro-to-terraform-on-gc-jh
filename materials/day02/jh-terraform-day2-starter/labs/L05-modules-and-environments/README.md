# L05: Extract a module and compare environments

Spans M09 and M10. You work in the ledgerlite root
(`labs/L01-build-and-parameterize/`).

| Part | Module | What you do | Evidence |
| --- | --- | --- | --- |
| A | M09 | Complete the `app_instance` module interface, call it from the root, apply the supplied `moved` mapping, document the module | Documented interface, usable outputs, a refactor plan with no unintended replacement or destruction |
| B | M10 | Confirm the selected workspace, see what an empty workspace does and does not know, choose an environment layout | The active workspace named, and a boundary justified with both state and identity |

## Files

| Path | Use |
| --- | --- |
| `starter/modules/app_instance/` | Module skeleton. Copy the `modules` directory into the ledgerlite root |
| `starter/app-module-call.tf` | The `module "app"` block that replaces the instance resource in `main.tf` |
| `starter/moved.tf` | Supplied migration mapping. Copy to the root as `moved.tf` when the guide says so |
| `output-reference-map.md` | Which module output replaces each resource reference in the root `outputs.tf` |
| `workspace-sandbox/` | A disposable configuration with local state for the workspace check |
| `environment-layouts.md` | Two proposed layouts for dev and test |

The startup template is not in the skeleton on purpose. You move your own
`templates/startup.sh.tftpl` into the module so the rendered script stays
byte-identical. One changed byte would force replacement of the instance.
