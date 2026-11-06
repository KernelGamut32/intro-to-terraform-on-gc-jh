# Two proposed layouts for ledgerlite dev and test

Platform Services needs a `test` environment next to `dev`. Two layouts are
on the table. Read both, then answer the questions.

## Layout A: one root, two CLI workspaces

```
ledgerlite/
  main.tf  variables.tf  outputs.tf  backend.tf
  modules/app_instance/

backend "gcs":  bucket = jh-tf-state-ledgerlite   prefix = ledgerlite

terraform workspace select dev    ->  gs://jh-tf-state-ledgerlite/ledgerlite/dev.tfstate
terraform workspace select test   ->  gs://jh-tf-state-ledgerlite/ledgerlite/test.tfstate
```

- One configuration directory, one backend, one bucket, one prefix.
- The runner identity that can write `dev.tfstate` can also write `test.tfstate`.
- Differences between environments are expressed with `terraform.workspace`
  conditionals or a variable file chosen by hand at plan time.
- The selected workspace is recorded locally in `.terraform/`; it is not
  visible in the code a reviewer reads.

## Layout B: one root per environment, shared modules

```
ledgerlite/
  modules/app_instance/
  environments/
    dev/    main.tf  backend.tf  terraform.tfvars
    test/   main.tf  backend.tf  terraform.tfvars

dev/backend.tf   bucket = jh-tf-state-ledgerlite-dev    prefix = ledgerlite
test/backend.tf  bucket = jh-tf-state-ledgerlite-test   prefix = ledgerlite

project:  jh-ledgerlite-dev                  jh-ledgerlite-test
runner:   tf-runner-dev@jh-ledgerlite-dev    tf-runner-test@jh-ledgerlite-test
```

- Each environment is its own root with its own backend, project, and runner identity.
- Each root uses the `default` workspace.
- Shared logic lives in modules; each root is small: a backend, a provider,
  inputs, and module calls.
- A reviewer sees which environment a change touches from the path of the file.

## Questions

1. The Release Management group must approve and run every change to `test`.
   Developers must not be able to read `test` state, because it will hold
   connection details for a shared test database. Which layout supports
   this? Name the boundary that enforces it.
2. For the layout you did not choose, describe one way a change intended
   for `dev` reaches `test`.
3. Name one legitimate use for a second CLI workspace on this team.
4. Which layout costs more to maintain, and what do you get for that cost?
