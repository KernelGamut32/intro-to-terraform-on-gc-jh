# Expected plan summary (M03, first apply)

```
Plan: 4 to add, 0 to change, 0 to destroy.
```

Resources and the action symbol you should see:

| Address | Action | Why |
| --- | --- | --- |
| `google_compute_network.main` | `+` create | New VPC |
| `google_compute_subnetwork.app` | `+` create | New subnet; references the network |
| `google_compute_firewall.allow_iap` | `+` create | References the network |
| `google_compute_instance.app` | `+` create | References the subnet |

Values shown as `(known after apply)` include the network and subnet `id`,
`self_link`, and the instance `network_interface[0].network_ip`.

After apply:

```
Apply complete! Resources: 4 added, 0 changed, 0 destroyed.

Outputs:

instance_name = "ledgerlite-app"
instance_zone = "us-central1-a"
```

A second `terraform plan` must end with:

```
No changes. Your infrastructure matches the configuration.
```
