# M04 plan-reading questions: answer key

The three questions and the expected answers.

## Question 1

Plan excerpt:

```
  # google_compute_instance.app will be updated in-place
  ~ resource "google_compute_instance" "app" {
        id           = "projects/jh-tf-lab-07/zones/us-central1-a/instances/ledgerlite-app"
      ~ labels       = {
          + "environment" = "dev"
            # (2 unchanged elements hidden)
        }
        name         = "ledgerlite-app"
        # (18 unchanged attributes hidden)
    }

Plan: 0 to add, 1 to change, 0 to destroy.
```

**What changes, and is the application interrupted?** One label is added to
the existing instance. Labels are updatable in place, so the instance keeps
its ID and keeps running. No interruption.

## Question 2

Plan excerpt:

```
  # google_compute_instance.app must be replaced
-/+ resource "google_compute_instance" "app" {
      ~ id           = "projects/.../instances/ledgerlite-app" -> (known after apply)
      ~ machine_type = "e2-small" -> "e2-medium" # forces replacement
      ...
    }

Plan: 1 to add, 0 to change, 1 to destroy.
```

**What changes, and what should the reviewer ask?** The machine type change
forces replacement: Terraform destroys the instance and creates a new one,
so the instance ID, boot disk, and internal IP (unless reserved) all change
and the application is down between destroy and create. The reviewer should
ask whether the change window allows an outage and whether anything depends
on the old instance ID or IP. (Day 2, M08 covers `create_before_destroy` and
deliberate replacement.) Note that in practice the Google provider can stop
and update the machine type of a stopped instance; this excerpt is the
replacement case and is presented as such.

## Question 3

Plan excerpt:

```
  # google_compute_firewall.allow_iap will be updated in-place
  ~ resource "google_compute_firewall" "allow_iap" {
      ~ source_ranges = [
          - "35.235.240.0/20",
          + "0.0.0.0/0",
        ]
    }

Plan: 0 to add, 1 to change, 0 to destroy.
```

**Should this plan be applied?** No. The summary line looks harmless (one
change, in place), but the change opens SSH and the application port to the
entire internet. This is why reviewers read the body of the plan, not only
the summary. The correct response is to reject the change and ask what
problem the author was trying to solve.
