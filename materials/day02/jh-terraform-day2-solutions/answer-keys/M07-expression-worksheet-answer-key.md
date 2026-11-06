# M07 worksheet: answer key

Values assume the lab defaults (`name_prefix = "ledgerlite"`,
`zone = "us-central1-a"`, `environment = "dev"`, `app_port = 8080`,
`labels = { cost_center = "cc-4410" }`) and the `instances` value from the
starter. The console prints typed collections with a conversion wrapper
(`tolist`, `tomap`, `toset`) and structural values (tuples and objects)
without one. Exact wrapping can differ slightly between Terraform releases;
the value and its type are what matter.

## Block 1

| # | Expression | Result | Type and note |
| --- | --- | --- | --- |
| 1 | `length(var.iap_source_ranges)` | `1` | number |
| 2 | `var.labels` | `tomap({ "cost_center" = "cc-4410" })` | `map(string)`: the variable declares the type, so the console shows `tomap` |
| 3 | `lookup(var.labels, "cost_center", "unassigned")` | `"cc-4410"` | string: the key exists |
| 4 | `lookup(var.labels, "owner", "unassigned")` | `"unassigned"` | string: the default is returned |
| 5 | `merge(var.labels, { environment = "test" }, { environment = "dev" })` | `{ "cost_center" = "cc-4410", "environment" = "dev" }` | object: later arguments win, so `dev` replaces `test` |
| 6 | `toset(["us-central1-a", "us-central1-b", "us-central1-a"])` | `toset([ "us-central1-a", "us-central1-b" ])` | `set(string)`: the duplicate is removed |
| 7 | `jsonencode({ app = var.name_prefix, ports = [22, var.app_port] })` | `"{\"app\":\"ledgerlite\",\"ports\":[22,8080]}"` | string: the console escapes the inner quotes |
| 8 | `[for r in var.iap_source_ranges : cidrhost(r, 1)]` | `[ "35.235.240.1" ]` | tuple: one result per input element |
| 9 | `var.environment == "dev" ? "e2-micro" : "e2-small"` | `"e2-micro"` | string |
| 10 | `provider::google::region_from_zone(var.zone)` | `"us-central1"` | string: a provider-defined function, called as `provider::NAME::FUNCTION` |
| 11 | `substr(templatefile(...), 0, 11)` | `"#!/bin/bash"` | string: `templatefile` returns the whole rendered script; `substr` keeps the first 11 characters |

## Block 2

| # | Expression | Result | Type and note |
| --- | --- | --- | --- |
| 12 | `keys(var.instances)` | `tolist([ "api", "batch" ])` | `list(string)`: map keys come back in lexical order |
| 13 | `{ for key, cfg in var.instances : key => cfg.zone }` | `{ "api" = "us-central1-a", "batch" = "us-central1-b" }` | object |
| 14 | `[for key, cfg in var.instances : key if cfg.zone != var.zone]` | `[ "batch" ]` | tuple: the `if` clause filters |
| 15 | `toset([for cfg in values(var.instances) : cfg.machine_type])` | `toset([ "e2-micro" ])` | `set(string)`: two instances, one distinct machine type |
| 16 | `local.instance_labels["batch"]` | `{ "app" = "ledgerlite", "cost_center" = "cc-4410", "environment" = "dev", "managed_by" = "terraform", "role" = "batch", "schedule" = "nightly", "team" = "platform-services", "tier" = "jobs" }` | object with eight attributes |
| 17 | `local.instance_names` | `{ "api" = "ledgerlite-api", "batch" = "ledgerlite-batch" }` | object |

Every row in the last column of the worksheet is **value**. None of the 17
expressions produces a nested block or a resource instance.

## The three questions

1. `dev` wins. `merge` applies its arguments from left to right, and a
   later argument replaces an earlier one for the same key. That is why the
   lab puts `{ role = key }` last: a caller cannot override it by accident.
2. The wrapper is the type. `var.labels` is declared `map(string)`, so
   every value must be a string. The `for` expression in row 13 builds an
   object, where each attribute could have its own type. Explicit types on
   inputs are what turn a wrong shape into an early, readable error.
3. None. Expressions produce values. Infrastructure changes only when a
   resource, or a nested block inside a resource, uses a value and a plan
   is applied.
