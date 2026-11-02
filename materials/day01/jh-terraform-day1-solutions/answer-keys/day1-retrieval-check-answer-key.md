# Day 1 retrieval check: answer key

Ask these at 16:55. Learners answer from their own configuration, plan, state
output, or worksheet.

| Question | Expected answer |
| --- | --- |
| What will this plan create, update, replace, or destroy? | Learner names a resource address and the symbol (`+`, `~`, `-/+`, `-`) and explains the effect on the running resource. Replacement means destroy then create; the identity changes. |
| How do inputs, data sources, and outputs connect? | `var.image_family` feeds `data.google_compute_image.app`; its `self_link` feeds the instance boot disk; `output "image_used"` exposes the resolved image name. Inputs flow in, data sources read, outputs flow out. |
| Which state and backend prefix are selected? | Bucket `jh-tf-state-lab-NN-xxxx`, prefix `labs/lab-NN`, object `default.tfstate`, verified with `gcloud storage ls` and `terraform state pull`. Two roots sharing bucket and prefix would overwrite each other's state. |
| Where could a secret or excessive permission remain? | State, saved plans, JSON output, logs, metadata; a project-level Owner or Editor grant. The fix is a runtime reference and narrow roles at narrow scope. |
| Why does `sensitive = true` not solve the problem? | It redacts CLI display only. The value is still in state and plans. |
| Why must the bucket exist before `terraform init`? | The backend is configured before any resources are planned; Terraform cannot create the bucket it is about to store state in. Bootstrap it separately. |
