# One change request, two plans

Three instances exist: `web`, `api`, and `worker`. The change request is
simple: retire `web`. The engineer deletes `"web"` from the input and
runs `terraform plan`.

The only difference between the two configurations is how the instances
were declared.

## Configuration A: `count` over a list

```hcl
variable "roles" {
  type    = list(string)
  default = ["web", "api", "worker"]
}

resource "google_compute_instance" "app" {
  count = length(var.roles)
  name  = "ledgerlite-${var.roles[count.index]}"
  # machine type, zone, boot disk, network interface
}
```

Plan after removing `"web"` from the list:

```
  # google_compute_instance.app[0] must be replaced
-/+ resource "google_compute_instance" "app" {
      ~ name = "ledgerlite-web" -> "ledgerlite-api" # forces replacement
        # (unchanged attributes hidden)
    }

  # google_compute_instance.app[1] must be replaced
-/+ resource "google_compute_instance" "app" {
      ~ name = "ledgerlite-api" -> "ledgerlite-worker" # forces replacement
        # (unchanged attributes hidden)
    }

  # google_compute_instance.app[2] will be destroyed
  # (because index [2] is out of range for count)
  - resource "google_compute_instance" "app" {
      - name = "ledgerlite-worker" -> null
        # (unchanged attributes hidden)
    }

Plan: 2 to add, 0 to change, 3 to destroy.
```

## Configuration B: `for_each` over a set of strings

```hcl
variable "roles" {
  type    = set(string)
  default = ["web", "api", "worker"]
}

resource "google_compute_instance" "app" {
  for_each = var.roles
  name     = "ledgerlite-${each.key}"
  # machine type, zone, boot disk, network interface
}
```

Plan after removing `"web"` from the set:

```
  # google_compute_instance.app["web"] will be destroyed
  # (because key ["web"] is not in for_each map)
  - resource "google_compute_instance" "app" {
      - name = "ledgerlite-web" -> null
        # (unchanged attributes hidden)
    }

Plan: 0 to add, 0 to change, 1 to destroy.
```

## Read the two plans and answer

1. In plan A, which running instances would be destroyed?
2. In plan A, the instance that ends up named `ledgerlite-api` is created at which address? Was that address previously the `api` instance?
3. In plan B, which addresses are not mentioned at all, and what does that tell you?
4. The change request said "retire web". Which plan does what was asked?
5. When is `count` still the right choice?

The plan excerpts are representative. Attribute lists are shortened.
