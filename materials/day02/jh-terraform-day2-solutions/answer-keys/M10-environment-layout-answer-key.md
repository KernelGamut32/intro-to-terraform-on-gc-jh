# M10 environment layouts: answer key

## Workspace check (expected evidence)

```
$ terraform workspace show
default

$ terraform workspace list
* default

$ gcloud storage ls gs://jh-tf-state-lab-07-4f2a/labs/lab-07/
gs://jh-tf-state-lab-07-4f2a/labs/lab-07/default.tfstate
```

A workspace named `test` on this backend would be the object
`gs://jh-tf-state-lab-07-4f2a/labs/lab-07/test.tfstate`: same bucket, same
prefix, same IAM.

Sandbox:

```
$ terraform workspace new scratch
Created and switched to workspace "scratch"!

$ terraform apply -auto-approve
Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

Outputs:

environment_name = "sandbox-scratch"
selected_workspace = "scratch"

$ terraform workspace select default
Switched to workspace "default".

$ terraform plan
  # terraform_data.marker will be created
Plan: 1 to add, 0 to change, 0 to destroy.

$ ls terraform.tfstate.d
scratch
```

The plan in `default` proposes a create because the `default` state is
empty. The object recorded in `scratch` still exists; this state simply
does not know about it.

## Layout questions

| # | Answer |
| --- | --- |
| 1 | Layout B. The boundary is the combination of a separate state bucket with its own IAM policy, a separate project, and a separate runner identity. Developers get no role on the test bucket, so they cannot read test state; only the Release Management runner can plan and apply in the test project. Layout A cannot do this: both states sit under one prefix in one bucket and are reachable with the same credentials |
| 2 | An engineer finishes a test investigation, forgets to run `terraform workspace select dev`, and applies. The code and the directory look identical; only `terraform workspace show` reveals the target. A `terraform.workspace` conditional with a typo is a second route |
| 3 | A temporary, disposable copy of the same infrastructure to try a change, for example one per feature branch in the dev project, destroyed and deleted when the branch merges. Same owners, same access, short life |
| 4 | Layout B costs more: two directories to keep in step, two backends, two sets of identities and roles. In return the path shows the target, access is enforceable per environment, and a mistake in one environment cannot write to the other's state |

## Supporting references for the debrief

- HashiCorp: CLI workspaces are not appropriate for deployments that
  require separate credentials and access controls.
- Google Cloud best practices for root modules: split each application into
  environment directories, each with its own backend and the default
  workspace, and avoid multiple CLI workspaces per environment.
- Terraform 1.15 and later refuses to apply a saved plan file in a
  workspace other than the one it was created in. That closes one route,
  not the interactive one.
