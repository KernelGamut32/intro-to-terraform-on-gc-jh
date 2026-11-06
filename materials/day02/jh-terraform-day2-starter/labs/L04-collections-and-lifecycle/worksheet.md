# M07 worksheet: predict, then check

Work in the ledgerlite root. For every row, write your prediction first.
Then run `terraform console`, type the expression, and compare. Type `exit`
to leave the console before you run any other Terraform command: the
console holds the state lock while it is open.

For the last column choose one: **value**, **nested block**, or
**resource instance**.

## Block 1: with the configuration exactly as Day 1 left it

| # | Expression | My prediction | Console result | Produces |
| --- | --- | --- | --- | --- |
| 1 | `length(var.iap_source_ranges)` | | | |
| 2 | `var.labels` | | | |
| 3 | `lookup(var.labels, "cost_center", "unassigned")` | | | |
| 4 | `lookup(var.labels, "owner", "unassigned")` | | | |
| 5 | `merge(var.labels, { environment = "test" }, { environment = "dev" })` | | | |
| 6 | `toset(["us-central1-a", "us-central1-b", "us-central1-a"])` | | | |
| 7 | `jsonencode({ app = var.name_prefix, ports = [22, var.app_port] })` | | | |
| 8 | `[for r in var.iap_source_ranges : cidrhost(r, 1)]` | | | |
| 9 | `var.environment == "dev" ? "e2-micro" : "e2-small"` | | | |
| 10 | `provider::google::region_from_zone(var.zone)` | | | |
| 11 | `substr(templatefile("${path.module}/templates/startup.sh.tftpl", { app_name = "x", app_port = 1, app_version = "v", environment = "e", team = "t" }), 0, 11)` | | | |

## Block 2: after you declare `instances` and add its value to `terraform.tfvars`

| # | Expression | My prediction | Console result | Produces |
| --- | --- | --- | --- | --- |
| 12 | `keys(var.instances)` | | | |
| 13 | `{ for key, cfg in var.instances : key => cfg.zone }` | | | |
| 14 | `[for key, cfg in var.instances : key if cfg.zone != var.zone]` | | | |
| 15 | `toset([for cfg in values(var.instances) : cfg.machine_type])` | | | |
| 16 | `local.instance_labels["batch"]` | | | |
| 17 | `local.instance_names` | | | |

## Three questions to answer in one sentence each

1. Row 5 passes `environment` twice. Which value wins, and why?
2. Rows 2 and 13 both print key and value pairs. The console prints one of them wrapped in `tomap(...)` and the other without a wrapper. What is the console telling you?
3. Which of the 17 expressions created or changed infrastructure?
