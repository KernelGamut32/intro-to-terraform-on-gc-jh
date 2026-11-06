# Change explanation: ledgerlite second placement (CR-2063)

Prepared by: ____________________   Reviewer: ____________________   Date: ____________

## What this change does

One or two sentences in plain language.

________________________________________________________________________________

## Scope

| Question | Answer |
| --- | --- |
| Root configuration (directory) | |
| State location (bucket and prefix) | |
| Selected workspace | |
| Project | |
| Region and zone | |
| Module and where it comes from | |

## Planned actions

Paste the table from `../../scripts/plan-summary.sh region2.tfplan`.

```

```

Plan summary line: `Plan: ___ to add, ___ to change, ___ to destroy.`

## What is shared and what is new

| Resource | Shared or new | Owner (root and state) |
| --- | --- | --- |
| VPC network | | |
| Firewall rule for IAP | | |
| Firewall rule for health checks | | |
| Subnet in us-east1 | | |
| Instance in us-east1 | | |

## Evidence that the primary deployment is untouched

Command you ran in the primary root and its result:

```

```

## What this change does not provide

Two regions is not high availability by itself. List what production
availability would still need.

1. ____________________________________________________________________________
2. ____________________________________________________________________________
3. ____________________________________________________________________________

## Outputs for the next team

| Output | Value (from the plan or the apply) |
| --- | --- |
| `instance_name` | |
| `instance_zone` | |
| `subnet_name` | |
| `shared_network` | |

## Discussion prompts

- Why does the second root read `network_name` from the primary root's outputs, and not from a `google_compute_network` data source?
- What does a reader of remote state gain access to, beyond the outputs?
- Why is no firewall rule in the plan, and why is the new instance still reachable through IAP?
- What would happen if both roots used the same backend prefix?
