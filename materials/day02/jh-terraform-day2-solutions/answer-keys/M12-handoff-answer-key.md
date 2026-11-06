# M12 handoff note: answer key

## Scope

| Question | Expected |
| --- | --- |
| Root configuration | `labs/L07-second-region` |
| State location | The learner's bucket, prefix `labs/lab-NN/us-east1` |
| Selected workspace | `default` |
| Project | The learner's lab project |
| Region and zone | `us-east1`, `us-east1-b` |
| Module | `app_instance`, local path `../L01-build-and-parameterize/modules/app_instance`. In production this would be a registry module or a Git source pinned to a tag |

## Planned actions

`Plan: 2 to add, 0 to change, 0 to destroy.`

| Resource | Shared or new | Owner |
| --- | --- | --- |
| VPC network | Shared | Primary root, prefix `labs/lab-NN` |
| Firewall rule for IAP | Shared (global, selects by tag) | Primary root |
| Firewall rule for health checks | Shared (global, selects by tag) | Primary root, since the import in L06 |
| Subnet in us-east1 | New | Second root, prefix `labs/lab-NN/us-east1` |
| Instance in us-east1 | New | Second root |

## Evidence that the primary is untouched

`terraform plan` in `labs/L01-build-and-parameterize` reports
`No changes.` The second root reads the primary state through
`terraform_remote_state`; it holds no lock on it and cannot write to it
through Terraform.

## What this change does not provide

Any three of:

1. Traffic routing between regions: a load balancer or DNS policy.
2. Health checks that take a failed region out of rotation. The firewall rule for the probes exists; the health check and backend service do not.
3. Data consistency: the application's data must be replicated or shared.
4. Operational design: runbooks, failover tests, capacity for one region to carry the full load, monitoring per region.
5. Release coordination: two roots can now drift apart in version unless the module source is pinned and promoted deliberately.

## Outputs for the next team

| Output | Expected value |
| --- | --- |
| `instance_name` | `ledgerlite-app-us-east1` |
| `instance_zone` | `us-east1-b` |
| `subnet_name` | `ledgerlite-subnet-us-east1` |
| `shared_network` | `ledgerlite-vpc` |

All four are known at plan time, so a learner who does not apply can still fill them in from `Changes to Outputs` in the plan.

## Discussion prompts and expected reasoning

The handout lists the first four prompts. The fifth is for the facilitator.

| Prompt | Expected reasoning |
| --- | --- |
| Why does the second root read `network_name` from remote state and not from a `google_compute_network` data source? | The network is managed by another Terraform configuration. Reading its published output makes the dependency explicit. A data source lookup by name creates a hidden dependency on a name the owner could change. Google Cloud's guidance is to use remote state for resources another configuration manages and data sources for resources Terraform does not manage, such as the image |
| What does a reader of remote state gain access to? | The whole state snapshot, not only the outputs. That is acceptable here, where one team owns both roots. Across teams, publish the few values needed somewhere with narrower access, or grant read on the state object deliberately |
| Why is no firewall rule in the plan? | VPC firewall rules are global and select instances by network tag. The module call passes the same tag |
| What would happen if both roots used the same prefix? | They would share one state. The second root's plan would propose destroying everything in the primary that its configuration does not declare |
| Facilitator extra: why is the second-region apply optional evidence? | The learning outcome is a correct, reviewed plan against the right state. Quota and time decide the apply |
