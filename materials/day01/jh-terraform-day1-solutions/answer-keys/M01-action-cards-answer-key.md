# M01 action cards: answer key

Learners classify each action by the tool or team responsible. Accept any
reasoning that correctly separates provisioning (Terraform), software
configuration (image, startup, configuration management), and human change
management.

| Card | Action | Responsible tool or team | Why |
| --- | --- | --- | --- |
| 1 | Create a subnet with the range 10.10.0.0/24 | Terraform (provisioning) | A cloud resource declared in configuration and tracked in state |
| 2 | Install the Python runtime inside the instance | Image build (Packer, Day 3) or startup / configuration management | Software inside the instance is not a Google Cloud resource |
| 3 | Approve a plan before it is applied | A human reviewer (change management) | Terraform produces the plan; a second person reads it |
| 4 | Rotate the billing API key stored in Secret Manager | Secret owner or rotation job, outside Terraform | Secret values should not pass through Terraform state |
| 5 | Record the mapping between `google_compute_instance.app` and instance ID 7324018855612090473 | Terraform state | State is the association between addresses and remote objects |
| 6 | Enable the Compute Engine API on a new project | Platform or foundation team (landing zone, Day 3), often Terraform at the foundation layer | Project-level prerequisites are owned above the application configuration |

Retrieval check (expected answer): editing a `.tf` file changes only the
desired configuration. Nothing in Google Cloud changes until a plan is
generated and applied, because Terraform compares configuration to state and
to the real resource, then performs the planned actions.
