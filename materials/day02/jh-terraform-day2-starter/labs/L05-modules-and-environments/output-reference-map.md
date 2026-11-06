# Root outputs after the module extraction

The root `outputs.tf` reads attributes of `google_compute_instance.app`.
That resource no longer exists in the root, so every reference must go
through an output of the module. Outputs are the module's only interface
back to the caller.

| Old reference in the root | New reference |
| --- | --- |
| `google_compute_instance.app.name` | `module.app.instance_name` |
| `google_compute_instance.app.zone` | `module.app.instance_zone` |
| `google_compute_instance.app.instance_id` | `module.app.instance_id` |
| `google_compute_instance.app.machine_type` | `module.app.machine_type` |
| `google_compute_instance.app.network_interface[0].network_ip` | `module.app.internal_ip` |

Where they appear: the outputs `instance_name`, `instance_zone`,
`internal_ip`, `ssh_command`, `tunnel_command`, and four lines inside
`inventory`.

`terraform validate` lists every reference you have not fixed yet:

```
Error: Reference to undeclared resource

  on outputs.tf line 3, in output "instance_name":
   3:   value       = google_compute_instance.app.name

A managed resource "google_compute_instance" "app" has not been declared in
the root module.
```

Fix one, run `terraform validate` again, and repeat until it reports
`Success! The configuration is valid.`
