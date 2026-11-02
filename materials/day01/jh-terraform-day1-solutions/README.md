# Day 1 solutions and checkpoints

Instructor copy. Each checkpoint directory is a complete root configuration
that represents the expected state of `labs/L01-build-and-parameterize/` at
the end of the named module. Use a checkpoint to unblock a learner or to
resume after a delay.

| Directory | Represents | How to use |
| --- | --- | --- |
| `checkpoints/M03-deployed/` | Part B complete: all TODO-M03 markers resolved | Copy over a learner's L01 directory, then `init`, `plan`, `apply` |
| `checkpoints/M04-parameterized/` | Part C guided section complete | Same as above; `terraform.tfvars` still needs the learner's values |
| `checkpoints/M04-change-request/` | CR-2041 complete | Reference answer for the change request |
| `checkpoints/M05-gcs-backend/` | L02 complete: `backend.tf` added | `terraform init -migrate-state` against a learner's bucket |
| `checkpoints/M06-secrets-corrected/` | L03 corrected design | Review only; shows the runtime-reference pattern and narrowed IAM |
| `answer-keys/` | Written answers for M01, M04, M06, and the Day 1 retrieval check | Facilitator use, release to learners after class if desired |

To move a learner onto a checkpoint without losing their deployment, copy the
checkpoint files over their directory but keep their `terraform.tfvars`,
`backend.tf`, and `.terraform.lock.hcl`. Resource addresses are identical
across checkpoints, so the next plan shows only the intended differences.
