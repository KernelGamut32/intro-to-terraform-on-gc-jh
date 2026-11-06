# Retrieval checks: answer key

## Before M07: where Day 1 left us

| Question | Expected answer |
| --- | --- |
| What does state associate, and where does ours live now? | State associates each resource address in the configuration with the real object it manages (for example `google_compute_instance.app` with the instance `ledgerlite-app`). Ours is the object `default.tfstate` under our prefix in the assigned GCS bucket, with Object Versioning on and locking handled by the backend |
| How do inputs, data sources, and outputs connect? | Inputs supply values the configuration cannot know. A data source reads an existing object (the newest `debian-13` image) and returns attributes. Resources use both. Outputs publish selected results for people and for automation, for example the `inventory` output read by `inventory.sh` |
| Why does a second unchanged plan matter? | It proves the configuration, the state, and the real infrastructure agree. A plan that is not empty after an apply means something is unstable: an argument the provider normalizes, an out-of-band change, or a value that changes on every run |

## Day 2 close

| Question | Expected answer |
| --- | --- |
| What will the plan create, update, replace, or destroy, and at which address? | Name the symbol (`+`, `~`, `-/+`, `-`), the full address including any key or module path, and the reason. Example: `-/+ google_compute_instance.fleet["batch"]`, replaced as requested |
| How does a value flow through a module to a non-secret output? | Root variable (`var.app_version`) to module input (`app.version`) to the resource argument (the rendered startup script). Back out: resource attribute (`network_interface[0].network_ip`) to module output (`internal_ip`) to root output (`inventory.internal_ip`) |
| Which workspace, root, and backend prefix are selected? | `default`; `labs/L01-build-and-parameterize` (primary) or `labs/L07-second-region`; `labs/lab-NN` or `labs/lab-NN/us-east1`. Confirm with `terraform workspace show` and the backend block |
| Which drift or import action fits the change request? | Approved and ours to own: change the configuration. Another owner's attribute: accept into state only. Unapproved: restore with a reviewed apply. Exists but unmanaged and should be ours: import with an `import` block and reconcile to a clean plan |
