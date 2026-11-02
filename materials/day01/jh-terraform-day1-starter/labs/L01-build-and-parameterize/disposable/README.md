# Disposable resource (M03 destroy practice)

This directory is its own Terraform root with its own state. It creates one
small persistent disk, which you then destroy. Nothing here touches the main
ledgerlite deployment.

```bash
cd disposable
terraform init
terraform plan -out=tfplan
terraform apply tfplan
terraform state list
terraform plan -destroy -out=destroy.tfplan
terraform show destroy.tfplan
terraform apply destroy.tfplan
```

Read the destroy plan before applying it. The summary line must say
`0 to add, 0 to change, 1 to destroy`.
